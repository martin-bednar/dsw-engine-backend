module Wizard.Service.Owl.Convertor.OwlConvertor where

import Control.Monad.IO.Class (MonadIO)
import Control.Monad.Reader (liftIO)
import Data.RDF
import qualified Data.Text as T
import Data.Time
import qualified Data.UUID as U

import Shared.Api.Resource.Event.EventJM ()
import Shared.Model.Common.MapEntry
import Shared.Model.Event.Chapter.ChapterEvent
import Shared.Model.Event.Event
import Shared.Model.Event.KnowledgeModel.KnowledgeModelEvent
import Shared.Model.Event.Question.QuestionEvent
import Shared.Model.KnowledgeModel.KnowledgeModel
import Shared.Util.String
import Shared.Util.Uuid
import Wizard.Util.Rdf

_MAP_ENTRY_RDF_TYPE :: String
_MAP_ENTRY_RDF_TYPE = "rdfType"

_MAP_ENTRY_RDF_RELATION :: String
_MAP_ENTRY_RDF_RELATION = "rdfRelation"

convertOwlToEvents :: MonadIO m => T.Text -> T.Text -> m [Event]
convertOwlToEvents rootElement text = do
  let result = parseString (TurtleParser Nothing Nothing) text :: Either ParseFailure (RDF TList)
  case result of
    Left err -> error "Unable to parse RDF content"
    Right graph -> do
      let rootClass = resolveClass graph rootElement
      convertToKnowledgeModel rootClass

convertToKnowledgeModel :: MonadIO m => RdfClass -> m [Event]
convertToKnowledgeModel rdfClass = do
  uuid <- liftIO generateUuid
  entityUuid <- liftIO generateUuid
  now <- liftIO getCurrentTime
  events <- convertToChapter entityUuid rdfClass
  let entityEvent =
        AddKnowledgeModelEvent' $
          AddKnowledgeModelEvent
            { uuid = uuid
            , parentUuid = U.nil
            , entityUuid = entityUuid
            , annotations = []
            , createdAt = now
            }
  return $ entityEvent : events

convertToChapter :: MonadIO m => U.UUID -> RdfClass -> m [Event]
convertToChapter parentUuid rdfClass = do
  uuid <- liftIO generateUuid
  entityUuid <- liftIO generateUuid
  now <- liftIO getCurrentTime
  events <- convertToQuestion entityUuid rdfClass
  let entityEvent =
        AddChapterEvent' $
          AddChapterEvent
            { uuid = uuid
            , parentUuid = parentUuid
            , entityUuid = entityUuid
            , title = "Chapter"
            , text = Nothing
            , annotations = []
            , createdAt = now
            }
  return $ entityEvent : events

convertToQuestion :: MonadIO m => U.UUID -> RdfClass -> m [Event]
convertToQuestion parentUuid (RdfClass nameT dataTypes objects) = do
  uuid <- liftIO generateUuid
  entityUuid <- liftIO generateUuid
  now <- liftIO getCurrentTime
  let name = T.unpack nameT
  let entityEvent =
        AddQuestionEvent' $
          AddListQuestionEvent' $
            AddListQuestionEvent
              { uuid = uuid
              , parentUuid = parentUuid
              , entityUuid = entityUuid
              , title = getTitle nameT
              , text = Just $ f' "%s: %s" [_MAP_ENTRY_RDF_TYPE, name]
              , requiredPhaseUuid = Nothing
              , annotations = [MapEntry _MAP_ENTRY_RDF_TYPE name]
              , tagUuids = []
              , createdAt = now
              }
  dataTypeEvents <- traverse (convertDataTypeToEvent entityUuid) dataTypes
  objectEvents <- traverse (convertObjectToEvent entityUuid) objects
  return $ [entityEvent] ++ dataTypeEvents ++ concat objectEvents

convertDataTypeToEvent :: MonadIO m => U.UUID -> RdfDataType -> m Event
convertDataTypeToEvent parentUuid (RdfDataType nameT rdfType) = do
  uuid <- liftIO generateUuid
  entityUuid <- liftIO generateUuid
  now <- liftIO getCurrentTime
  let name = T.unpack nameT
  let valueType =
        case rdfType of
          "http://www.w3.org/2001/XMLSchema#anyURI" -> UrlQuestionValueType
          "http://www.w3.org/2001/XMLSchema#date" -> DateQuestionValueType
          "http://www.w3.org/2001/XMLSchema#dateTime" -> DateTimeQuestionValueType
          "http://www.w3.org/2001/XMLSchema#time" -> TimeQuestionValueType
          "http://www.w3.org/2001/XMLSchema#decimal" -> NumberQuestionValueType
          "http://www.w3.org/2001/XMLSchema#double" -> NumberQuestionValueType
          "http://www.w3.org/2001/XMLSchema#float" -> NumberQuestionValueType
          "http://www.w3.org/2001/XMLSchema#integer" -> NumberQuestionValueType
          "http://www.w3.org/2001/XMLSchema#string" -> StringQuestionValueType
          _ -> StringQuestionValueType
  return $
    AddQuestionEvent' $
      AddValueQuestionEvent' $
        AddValueQuestionEvent
          { uuid = uuid
          , parentUuid = parentUuid
          , entityUuid = entityUuid
          , title = getTitle nameT
          , text = Just $ f' "%s: %s" [_MAP_ENTRY_RDF_TYPE, name]
          , requiredPhaseUuid = Nothing
          , tagUuids = []
          , annotations = [MapEntry _MAP_ENTRY_RDF_TYPE name]
          , valueType = valueType
          , createdAt = now
          }

convertObjectToEvent :: MonadIO m => U.UUID -> RdfObject -> m [Event]
convertObjectToEvent parentUuid (RdfObject objName rdfType (RdfClass nameT dataTypes objects)) = do
  uuid <- liftIO generateUuid
  entityUuid <- liftIO generateUuid
  now <- liftIO getCurrentTime
  let name = T.unpack nameT
  let entityEvent =
        AddQuestionEvent' $
          AddListQuestionEvent' $
            AddListQuestionEvent
              { uuid = uuid
              , parentUuid = parentUuid
              , entityUuid = entityUuid
              , title = getTitle nameT
              , text =
                  Just $ f' "%s: %s, %s: %s" [_MAP_ENTRY_RDF_TYPE, name, _MAP_ENTRY_RDF_RELATION, T.unpack objName]
              , requiredPhaseUuid = Nothing
              , annotations =
                  [MapEntry _MAP_ENTRY_RDF_TYPE name, MapEntry "rdfRelation" (T.unpack objName)]
              , tagUuids = []
              , createdAt = now
              }
  dataTypeEvents <- traverse (convertDataTypeToEvent entityUuid) dataTypes
  objectEvents <- traverse (convertObjectToEvent entityUuid) objects
  return $ [entityEvent] ++ dataTypeEvents ++ concat objectEvents

getTitle :: T.Text -> String
getTitle name =
  if '#' `elem` T.unpack name
    then T.unpack . T.toTitle . T.pack . unwords . fromHumps . T.unpack $ T.splitOn "#" name !! 1
    else T.unpack . T.toTitle . T.pack . unwords . fromHumps . T.unpack . last $ T.splitOn "/" name

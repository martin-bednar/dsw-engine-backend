module Wizard.Database.DAO.Document.DocumentDAO where

import Control.Monad.Reader (asks)
import Data.Maybe
import Data.String
import qualified Data.UUID as U
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.ToField
import GHC.Int

import Shared.Model.Common.Page
import Shared.Model.Common.Pageable
import Shared.Model.Common.Sort
import Wizard.Database.DAO.Common
import Wizard.Database.Mapping.Document.Document ()
import Wizard.Model.Context.AppContext
import Wizard.Model.Context.ContextLenses ()
import Wizard.Model.Document.Document
import Wizard.Util.Logger

entityName = "document"

pageLabel = "documents"

findDocuments :: AppContextM [Document]
findDocuments = do
  appUuid <- asks _appContextAppUuid
  createFindEntitiesByFn entityName [appQueryUuid appUuid]

findDocumentsFiltered :: [(String, String)] -> AppContextM [Document]
findDocumentsFiltered params = do
  appUuid <- asks _appContextAppUuid
  createFindEntitiesByFn entityName (appQueryUuid appUuid : params)

findDocumentsPage :: Maybe String -> Maybe String -> Pageable -> [Sort] -> AppContextM (Page Document)
findDocumentsPage mQtnUuid mQuery pageable sort = do
  appUuid <- asks _appContextAppUuid
  createFindEntitiesPageableQuerySortFn
    entityName
    pageLabel
    pageable
    sort
    "*"
    (if isJust mQtnUuid
       then "app_uuid = ? AND name ~* ? AND questionnaire_uuid = ? AND durability='PersistentDocumentDurability'"
       else "app_uuid = ? AND name ~* ? AND durability='PersistentDocumentDurability'")
    (U.toString appUuid : regex mQuery : maybeToList mQtnUuid)

findDocumentsByQuestionnaireUuidPage :: String -> Maybe String -> Pageable -> [Sort] -> AppContextM (Page Document)
findDocumentsByQuestionnaireUuidPage qtnUuid mQuery pageable sort = do
  appUuid <- asks _appContextAppUuid
  createFindEntitiesPageableQuerySortFn
    entityName
    pageLabel
    pageable
    sort
    "*"
    "app_uuid = ? AND name ~* ? AND questionnaire_uuid = ? AND durability='PersistentDocumentDurability'"
    (U.toString appUuid : regex mQuery : [qtnUuid])

findDocumentsByTemplateId :: String -> AppContextM [Document]
findDocumentsByTemplateId templateId = do
  appUuid <- asks _appContextAppUuid
  createFindEntitiesByFn entityName [appQueryUuid appUuid, ("template_id", templateId)]

findDocumentById :: String -> AppContextM Document
findDocumentById uuid = do
  appUuid <- asks _appContextAppUuid
  createFindEntityByFn entityName [appQueryUuid appUuid, ("uuid", uuid)]

insertDocument :: Document -> AppContextM Int64
insertDocument = createInsertFn entityName

deleteDocuments :: AppContextM Int64
deleteDocuments = createDeleteEntitiesFn entityName

deleteDocumentsFiltered :: [(String, String)] -> AppContextM Int64
deleteDocumentsFiltered params = do
  appUuid <- asks _appContextAppUuid
  createDeleteEntitiesByFn entityName (appQueryUuid appUuid : params)

deleteDocumentById :: String -> AppContextM Int64
deleteDocumentById uuid = do
  appUuid <- asks _appContextAppUuid
  createDeleteEntityByFn entityName [appQueryUuid appUuid, ("uuid", uuid)]

deleteTemporalDocumentsByQuestionnaireUuid :: String -> AppContextM Int64
deleteTemporalDocumentsByQuestionnaireUuid qtnUuid = do
  appUuid <- asks _appContextAppUuid
  deleteDocumentsFiltered
    [appQueryUuid appUuid, ("questionnaire_uuid", qtnUuid), ("durability", "TemporallyDocumentDurability")]

deleteTemporalDocumentsByTemplateId :: String -> AppContextM Int64
deleteTemporalDocumentsByTemplateId templateId = do
  appUuid <- asks _appContextAppUuid
  deleteDocumentsFiltered
    [appQueryUuid appUuid, ("template_id", templateId), ("durability", "TemporallyDocumentDurability")]

deleteTemporalDocumentsByTemplateAssetId :: String -> AppContextM Int64
deleteTemporalDocumentsByTemplateAssetId = deleteTemporalDocumentsByTableAndId "template_asset"

deleteTemporalDocumentsByTemplateFileId :: String -> AppContextM Int64
deleteTemporalDocumentsByTemplateFileId = deleteTemporalDocumentsByTableAndId "template_file"

-- --------------------------------
-- PRIVATE
-- --------------------------------
deleteTemporalDocumentsByTableAndId :: String -> String -> AppContextM Int64
deleteTemporalDocumentsByTableAndId joinTableName entityUuid = do
  appUuid <- asks _appContextAppUuid
  let sql =
        f'
          "DELETE \
          \FROM document \
          \WHERE app_uuid = ? AND uuid IN ( \
          \    SELECT d.uuid \
          \    FROM %s join_table \
          \             JOIN document d ON join_table.template_id = d.template_id \
          \    WHERE join_table.uuid = '%s' \
          \      AND d.durability = 'TemporallyDocumentDurability' \
          \)"
          [joinTableName, entityUuid]
  logInfoU _CMP_DATABASE sql
  let action conn = execute conn (fromString sql) [toField appUuid]
  runDB action

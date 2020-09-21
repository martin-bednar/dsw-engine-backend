module Wizard.Service.Submission.SubmissionService where

import Control.Lens ((^.))
import Control.Monad.Except (throwError)
import Control.Monad.Reader (asks)
import qualified Data.List as L
import qualified Data.Map.Strict as M
import qualified Data.UUID as U

import LensesConfig
import Shared.Model.Error.Error
import Wizard.Api.Resource.Submission.SubmissionCreateDTO
import Wizard.Api.Resource.Submission.SubmissionDTO
import Wizard.Api.Resource.Submission.SubmissionServiceSimpleDTO
import Wizard.Database.DAO.Document.DocumentDAO
import Wizard.Integration.Http.Submission.Runner
import Wizard.Localization.Messages.Public
import Wizard.Model.Config.AppConfig
import Wizard.Model.Context.AppContext
import Wizard.Model.Document.Document
import Wizard.Service.Common
import Wizard.Service.Config.AppConfigService
import Wizard.Service.Document.DocumentACL
import Wizard.Service.Submission.SubmissionMapper
import Wizard.Service.User.UserProfileService

getAvailableServicesForSubmission :: String -> AppContextM [SubmissionServiceSimpleDTO]
getAvailableServicesForSubmission docUuid = do
  appConfig <- getAppConfig
  doc <- findDocumentById docUuid
  checkEditPermissionToDoc (U.toString $ doc ^. questionnaireUuid)
  return . fmap toSubmissionServiceSimpleDTO . filter (filterService doc) $ appConfig ^. submission . services
  where
    filterService :: Document -> AppConfigSubmissionService -> Bool
    filterService doc service = any (filterServiceFormat doc) $ service ^. supportedFormats
    filterServiceFormat :: Document -> AppConfigSubmissionServiceSupportedFormat -> Bool
    filterServiceFormat doc supportedFormat =
      (supportedFormat ^. templateId == doc ^. templateId) && (supportedFormat ^. formatUuid == doc ^. formatUuid)

submitDocument :: SubmissionCreateDTO -> AppContextM SubmissionDTO
submitDocument reqDto = do
  checkIfSubmissionIsEnabled
  appConfig <- getAppConfig
  case L.find (\s -> s ^. sId == (reqDto ^. serviceId)) (appConfig ^. submission . services) of
    Just definition -> do
      doc <- findDocumentById (U.toString $ reqDto ^. docUuid)
      checkEditPermissionToDoc (U.toString $ doc ^. questionnaireUuid)
      docContent <- findDocumentContent (U.toString $ reqDto ^. docUuid)
      userProps <- getUserProps definition
      uploadDocument (definition ^. request) userProps docContent
    Nothing -> throwError . UserError $ _ERROR_VALIDATION__SUBMISSION_DEFINITION_ABSENCE (reqDto ^. serviceId)
  where
    getUserProps definition = do
      mUser <- asks _appContextCurrentUser
      case mUser of
        Just user -> do
          profile <- getUserProfile (U.toString $ user ^. uuid)
          let mUserProps = L.find (\p -> (p ^. sId) == (definition ^. sId)) (profile ^. submissionProps)
          return $
            case mUserProps of
              Just p -> p ^. values
              Nothing -> M.empty
        Nothing -> return M.empty

-- --------------------------------
-- PRIVATE
-- --------------------------------
checkIfSubmissionIsEnabled = checkIfAppFeatureIsEnabled "Submission" (submission . enabled)

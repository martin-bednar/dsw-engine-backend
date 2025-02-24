module Wizard.Service.Migration.Questionnaire.MigratorService where

import Control.Monad.Reader (asks, liftIO)
import qualified Data.UUID as U

import Shared.Util.Uuid
import Wizard.Api.Resource.Migration.Questionnaire.MigratorStateChangeDTO
import Wizard.Api.Resource.Migration.Questionnaire.MigratorStateCreateDTO
import Wizard.Api.Resource.Migration.Questionnaire.MigratorStateDTO
import Wizard.Api.Resource.Questionnaire.QuestionnaireDetailDTO
import Wizard.Database.DAO.Common
import Wizard.Database.DAO.Migration.Questionnaire.MigratorDAO
import Wizard.Database.DAO.Questionnaire.QuestionnaireDAO
import Wizard.Model.Context.AppContext
import Wizard.Model.Migration.Questionnaire.MigratorState
import Wizard.Model.Questionnaire.Questionnaire
import Wizard.Model.Questionnaire.QuestionnaireAcl
import Wizard.Service.Acl.AclService
import Wizard.Service.KnowledgeModel.KnowledgeModelService
import Wizard.Service.Migration.Questionnaire.Migrator.Sanitizator
import Wizard.Service.Migration.Questionnaire.MigratorAudit
import Wizard.Service.Migration.Questionnaire.MigratorMapper
import Wizard.Service.Questionnaire.QuestionnaireAcl
import Wizard.Service.Questionnaire.QuestionnaireService

createQuestionnaireMigration :: String -> MigratorStateCreateDTO -> AppContextM MigratorStateDTO
createQuestionnaireMigration oldQtnUuid reqDto =
  runInTransaction $ do
    checkPermission _QTN_PERM
    oldQtn <- findQuestionnaireById oldQtnUuid
    checkMigrationPermissionToQtn oldQtn.visibility oldQtn.permissions
    newQtn <- upgradeQuestionnaire reqDto oldQtn
    insertQuestionnaire newQtn
    appUuid <- asks currentAppUuid
    let state = fromCreateDTO oldQtn.uuid newQtn.uuid appUuid
    insertMigratorState state
    auditQuestionnaireMigrationCreate reqDto oldQtn newQtn
    getQuestionnaireMigration (U.toString $ newQtn.uuid)

getQuestionnaireMigration :: String -> AppContextM MigratorStateDTO
getQuestionnaireMigration qtnUuid = do
  checkPermission _QTN_PERM
  state <- findMigratorStateByNewQuestionnaireId qtnUuid
  oldQtnDto <- getQuestionnaireDetailById (U.toString state.oldQuestionnaireUuid)
  newQtnDto <- getQuestionnaireDetailById (U.toString state.newQuestionnaireUuid)
  oldQtn <- findQuestionnaireById (U.toString state.oldQuestionnaireUuid)
  newQtn <- findQuestionnaireById (U.toString state.newQuestionnaireUuid)
  checkMigrationPermissionToQtn oldQtn.visibility oldQtn.permissions
  checkMigrationPermissionToQtn newQtn.visibility newQtn.permissions
  return $ toDTO oldQtnDto newQtnDto state.resolvedQuestionUuids state.appUuid

modifyQuestionnaireMigration :: String -> MigratorStateChangeDTO -> AppContextM MigratorStateDTO
modifyQuestionnaireMigration qtnUuid reqDto =
  runInTransaction $ do
    checkPermission _QTN_PERM
    state <- getQuestionnaireMigration qtnUuid
    let updatedState = fromChangeDTO reqDto state
    updateMigratorStateByNewQuestionnaireId updatedState
    auditQuestionnaireMigrationModify state reqDto
    return $ toDTO state.oldQuestionnaire state.newQuestionnaire updatedState.resolvedQuestionUuids updatedState.appUuid

finishQuestionnaireMigration :: String -> AppContextM ()
finishQuestionnaireMigration qtnUuid =
  runInTransaction $ do
    checkPermission _QTN_PERM
    _ <- getQuestionnaireMigration qtnUuid
    state <- findMigratorStateByNewQuestionnaireId qtnUuid
    deleteMigratorStateByNewQuestionnaireId qtnUuid
    oldQtn <- findQuestionnaireById (U.toString state.oldQuestionnaireUuid)
    newQtn <- findQuestionnaireById (U.toString state.newQuestionnaireUuid)
    let updatedQtn =
          oldQtn
            { formatUuid = newQtn.formatUuid
            , templateId = newQtn.templateId
            , selectedQuestionTagUuids = newQtn.selectedQuestionTagUuids
            , packageId = newQtn.packageId
            , events = newQtn.events
            }
          :: Questionnaire
    updateQuestionnaireById updatedQtn
    deleteQuestionnaire (U.toString $ newQtn.uuid) False
    auditQuestionnaireMigrationFinish oldQtn newQtn
    return ()

cancelQuestionnaireMigration :: String -> AppContextM ()
cancelQuestionnaireMigration qtnUuid =
  runInTransaction $ do
    checkPermission _QTN_PERM
    state <- getQuestionnaireMigration qtnUuid
    deleteQuestionnaire (U.toString $ state.newQuestionnaire.uuid) True
    deleteMigratorStateByNewQuestionnaireId qtnUuid
    auditQuestionnaireMigrationCancel state
    return ()

-- --------------------------------
-- PRIVATE
-- --------------------------------
upgradeQuestionnaire :: MigratorStateCreateDTO -> Questionnaire -> AppContextM Questionnaire
upgradeQuestionnaire reqDto oldQtn = do
  let newPkgId = reqDto.targetPackageId
  let newTagUuids = reqDto.targetTagUuids
  oldKm <- compileKnowledgeModel [] (Just oldQtn.packageId) newTagUuids
  newKm <- compileKnowledgeModel [] (Just newPkgId) newTagUuids
  newUuid <- liftIO generateUuid
  newEvents <- sanitizeQuestionnaireEvents oldKm newKm oldQtn.events
  newPermissions <- traverse (upgradeQuestionnairePerm newUuid) oldQtn.permissions
  let upgradedQtn =
        oldQtn
          { uuid = newUuid
          , packageId = newPkgId
          , events = newEvents
          , selectedQuestionTagUuids = newTagUuids
          , templateId = Nothing
          , formatUuid = Nothing
          , permissions = newPermissions
          }
        :: Questionnaire
  return upgradedQtn

upgradeQuestionnairePerm :: U.UUID -> QuestionnairePermRecord -> AppContextM QuestionnairePermRecord
upgradeQuestionnairePerm newQtnUuid perm = do
  newUuid <- liftIO generateUuid
  let upgradedPerm =
        perm
          { uuid = newUuid
          , questionnaireUuid = newQtnUuid
          }
  return upgradedPerm

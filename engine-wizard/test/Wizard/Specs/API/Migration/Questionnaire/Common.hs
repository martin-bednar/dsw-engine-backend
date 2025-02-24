module Wizard.Specs.API.Migration.Questionnaire.Common where

import Data.Either (isRight)
import qualified Data.UUID as U
import Test.Hspec
import Test.Hspec.Wai hiding (shouldRespondWith)

import Shared.Api.Resource.Error.ErrorJM ()
import Wizard.Database.DAO.Migration.Questionnaire.MigratorDAO
import Wizard.Model.Migration.Questionnaire.MigratorState

import Wizard.Specs.API.Questionnaire.Common
import Wizard.Specs.Common

-- --------------------------------
-- ASSERTS
-- --------------------------------
assertExistenceOfMigrationStateInDB appContext entity = do
  eEntitiesFromDb <-
    runInContextIO (findMigratorStatesByOldQuestionnaireId (U.toString $ entity.oldQuestionnaireUuid)) appContext
  liftIO $ isRight eEntitiesFromDb `shouldBe` True
  let (Right entitiesFromDb) = eEntitiesFromDb
  liftIO $ length entitiesFromDb `shouldBe` 1
  let entityFromDb = head entitiesFromDb
  compareQtnMigrators entityFromDb entity

-- --------------------------------
-- COMPARATORS
-- --------------------------------
compareQtnMigrators resDto expDto = do
  liftIO $ resDto.oldQuestionnaireUuid `shouldBe` expDto.oldQuestionnaireUuid
  liftIO $ resDto.newQuestionnaireUuid `shouldBe` expDto.newQuestionnaireUuid
  liftIO $ resDto.resolvedQuestionUuids `shouldBe` expDto.resolvedQuestionUuids

compareQtnMigratorDtos resDto expDto = do
  compareQuestionnaireCreateDtos' resDto.oldQuestionnaire expDto.oldQuestionnaire
  compareQuestionnaireCreateDtos' resDto.newQuestionnaire expDto.newQuestionnaire
  liftIO $ resDto.resolvedQuestionUuids `shouldBe` expDto.resolvedQuestionUuids

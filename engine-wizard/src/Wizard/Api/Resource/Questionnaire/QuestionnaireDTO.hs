module Wizard.Api.Resource.Questionnaire.QuestionnaireDTO where

import Data.Time
import qualified Data.UUID as U
import GHC.Generics

import Shared.Model.Package.PackageSimple
import Wizard.Api.Resource.Questionnaire.QuestionnaireAclDTO
import Wizard.Api.Resource.Questionnaire.QuestionnaireReportDTO
import Wizard.Model.Questionnaire.Questionnaire
import Wizard.Model.Questionnaire.QuestionnaireState

data QuestionnaireDTO =
  QuestionnaireDTO
    { _questionnaireDTOUuid :: U.UUID
    , _questionnaireDTOName :: String
    , _questionnaireDTODescription :: Maybe String
    , _questionnaireDTOPhaseUuid :: Maybe U.UUID
    , _questionnaireDTOVisibility :: QuestionnaireVisibility
    , _questionnaireDTOSharing :: QuestionnaireSharing
    , _questionnaireDTOState :: QuestionnaireState
    , _questionnaireDTOPackage :: PackageSimple
    , _questionnaireDTOReport :: QuestionnaireReportDTO
    , _questionnaireDTOPermissions :: [QuestionnairePermRecordDTO]
    , _questionnaireDTOIsTemplate :: Bool
    , _questionnaireDTOCreatedAt :: UTCTime
    , _questionnaireDTOUpdatedAt :: UTCTime
    }
  deriving (Show, Generic)

instance Eq QuestionnaireDTO where
  a == b =
    _questionnaireDTOUuid a == _questionnaireDTOUuid b &&
    _questionnaireDTOName a == _questionnaireDTOName b &&
    _questionnaireDTODescription a == _questionnaireDTODescription b &&
    _questionnaireDTOPhaseUuid a == _questionnaireDTOPhaseUuid b &&
    _questionnaireDTOVisibility a == _questionnaireDTOVisibility b &&
    _questionnaireDTOSharing a == _questionnaireDTOSharing b &&
    _questionnaireDTOState a == _questionnaireDTOState b &&
    _questionnaireDTOPackage a == _questionnaireDTOPackage b &&
    _questionnaireDTOReport a == _questionnaireDTOReport b &&
    _questionnaireDTOPermissions a == _questionnaireDTOPermissions b &&
    _questionnaireDTOIsTemplate a == _questionnaireDTOIsTemplate b

module Wizard.Api.Handler.Migration.Questionnaire.List_Current_DELETE where

import Servant

import Shared.Api.Handler.Common
import Shared.Model.Context.TransactionState
import Wizard.Api.Handler.Common
import Wizard.Model.Context.BaseContext
import Wizard.Service.Migration.Questionnaire.MigratorService

type List_Current_DELETE =
  Header "Authorization" String
    :> Header "Host" String
    :> "questionnaires"
    :> Capture "qtnUuid" String
    :> "migrations"
    :> "current"
    :> Verb DELETE 204 '[SafeJSON] (Headers '[Header "x-trace-uuid" String] NoContent)

list_current_DELETE
  :: Maybe String -> Maybe String -> String -> BaseContextM (Headers '[Header "x-trace-uuid" String] NoContent)
list_current_DELETE mTokenHeader mServerUrl qtnUuid =
  getAuthServiceExecutor mTokenHeader mServerUrl $ \runInAuthService ->
    runInAuthService Transactional $
      addTraceUuidHeader =<< do
        cancelQuestionnaireMigration qtnUuid
        return NoContent

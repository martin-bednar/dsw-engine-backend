module Wizard.Api.Handler.Template.List_POST where

import Servant

import Shared.Api.Handler.Common
import Shared.Model.Context.TransactionState
import Shared.Model.Template.Template
import Shared.Model.Template.TemplateJM ()
import Wizard.Api.Handler.Common
import Wizard.Api.Resource.Template.TemplateChangeDTO
import Wizard.Api.Resource.Template.TemplateChangeJM ()
import Wizard.Model.Context.BaseContext
import Wizard.Service.Template.TemplateService

type List_POST =
  Header "Authorization" String
    :> Header "Host" String
    :> ReqBody '[SafeJSON] TemplateChangeDTO
    :> "templates"
    :> PostCreated '[SafeJSON] (Headers '[Header "x-trace-uuid" String] Template)

list_POST
  :: Maybe String
  -> Maybe String
  -> TemplateChangeDTO
  -> BaseContextM (Headers '[Header "x-trace-uuid" String] Template)
list_POST mTokenHeader mServerUrl reqDto =
  getAuthServiceExecutor mTokenHeader mServerUrl $ \runInAuthService ->
    runInAuthService Transactional $ addTraceUuidHeader =<< createTemplate reqDto

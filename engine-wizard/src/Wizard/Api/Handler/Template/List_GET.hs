module Wizard.Api.Handler.Template.List_GET where

import Servant

import Shared.Api.Handler.Common
import Shared.Model.Common.Page
import Shared.Model.Common.Pageable
import Shared.Model.Context.TransactionState
import Wizard.Api.Handler.Common
import Wizard.Api.Resource.Template.TemplateSimpleDTO
import Wizard.Model.Context.BaseContext
import Wizard.Service.Template.TemplateService

type List_GET =
  Header "Authorization" String
    :> Header "Host" String
    :> "templates"
    :> QueryParam "organizationId" String
    :> QueryParam "templateId" String
    :> QueryParam "q" String
    :> QueryParam "state" String
    :> QueryParam "page" Int
    :> QueryParam "size" Int
    :> QueryParam "sort" String
    :> Get '[SafeJSON] (Headers '[Header "x-trace-uuid" String] (Page TemplateSimpleDTO))

list_GET
  :: Maybe String
  -> Maybe String
  -> Maybe String
  -> Maybe String
  -> Maybe String
  -> Maybe String
  -> Maybe Int
  -> Maybe Int
  -> Maybe String
  -> BaseContextM (Headers '[Header "x-trace-uuid" String] (Page TemplateSimpleDTO))
list_GET mTokenHeader mServerUrl mOrganizationId mTmlId mQuery mState mPage mSize mSort =
  getAuthServiceExecutor mTokenHeader mServerUrl $ \runInAuthService ->
    runInAuthService NoTransaction $
      addTraceUuidHeader
        =<< getTemplatesPage mOrganizationId mTmlId mQuery mState (Pageable mPage mSize) (parseSortQuery mSort)

module Wizard.Api.Handler.Template.Api where

import Servant
import Servant.Swagger.Tags

import Wizard.Api.Handler.Template.Asset.Api
import Wizard.Api.Handler.Template.Detail_Bundle_GET
import Wizard.Api.Handler.Template.Detail_DELETE
import Wizard.Api.Handler.Template.Detail_GET
import Wizard.Api.Handler.Template.Detail_PUT
import Wizard.Api.Handler.Template.Detail_Pull_POST
import Wizard.Api.Handler.Template.File.Api
import Wizard.Api.Handler.Template.List_All_GET
import Wizard.Api.Handler.Template.List_Bundle_POST
import Wizard.Api.Handler.Template.List_DELETE
import Wizard.Api.Handler.Template.List_GET
import Wizard.Api.Handler.Template.List_POST
import Wizard.Api.Handler.Template.List_Suggestions_GET
import Wizard.Model.Context.BaseContext

type TemplateAPI =
  Tags "Template"
    :> ( TemplateAssetAPI
          :<|> TemplateFileAPI
          :<|> List_GET
          :<|> List_All_GET
          :<|> List_Suggestions_GET
          :<|> List_POST
          :<|> List_DELETE
          :<|> Detail_GET
          :<|> Detail_PUT
          :<|> Detail_DELETE
          :<|> List_Bundle_POST
          :<|> Detail_Bundle_GET
          :<|> Detail_Pull_POST
       )

templateApi :: Proxy TemplateAPI
templateApi = Proxy

templateServer :: ServerT TemplateAPI BaseContextM
templateServer =
  templateAssetServer
    :<|> templateFileServer
    :<|> list_GET
    :<|> list_all_GET
    :<|> list_suggestions_GET
    :<|> list_POST
    :<|> list_DELETE
    :<|> detail_GET
    :<|> detail_PUT
    :<|> detail_DELETE
    :<|> list_bundle_POST
    :<|> detail_bundle_GET
    :<|> detail_pull_POST

module Wizard.Api.Handler.ActionKey.Api where

import Servant
import Servant.Swagger.Tags

import Wizard.Api.Handler.ActionKey.List_POST
import Wizard.Model.Context.BaseContext

type ActionKeyAPI =
  Tags "Action"
    :> List_POST

actionKeyApi :: Proxy ActionKeyAPI
actionKeyApi = Proxy

actionKeyServer :: ServerT ActionKeyAPI BaseContextM
actionKeyServer = list_POST

module Wizard.Api.Handler.Typehint.List_POST where

import Servant

import Shared.Api.Handler.Common
import Shared.Model.Context.TransactionState
import Wizard.Api.Handler.Common
import Wizard.Api.Resource.Typehint.TypehintDTO
import Wizard.Api.Resource.Typehint.TypehintJM ()
import Wizard.Api.Resource.Typehint.TypehintRequestDTO
import Wizard.Api.Resource.Typehint.TypehintRequestJM ()
import Wizard.Model.Context.BaseContext
import Wizard.Service.Typehint.TypehintService

type List_POST =
  Header "Authorization" String
    :> Header "Host" String
    :> ReqBody '[SafeJSON] TypehintRequestDTO
    :> "typehints"
    :> Post '[SafeJSON] (Headers '[Header "x-trace-uuid" String] [TypehintDTO])

list_POST
  :: Maybe String
  -> Maybe String
  -> TypehintRequestDTO
  -> BaseContextM (Headers '[Header "x-trace-uuid" String] [TypehintDTO])
list_POST mTokenHeader mServerUrl reqDto =
  getMaybeAuthServiceExecutor mTokenHeader mServerUrl $ \runInMaybeAuthService ->
    runInMaybeAuthService Transactional $ addTraceUuidHeader =<< getTypehints reqDto

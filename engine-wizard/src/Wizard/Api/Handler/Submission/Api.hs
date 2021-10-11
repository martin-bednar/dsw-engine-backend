module Wizard.Api.Handler.Submission.Api where

import Servant

import Wizard.Api.Handler.Submission.List_GET
import Wizard.Api.Handler.Submission.List_POST
import Wizard.Model.Context.BaseContext

type SubmissionAPI
   = List_GET
     :<|> List_POST

submissionApi :: Proxy SubmissionAPI
submissionApi = Proxy

submissionServer :: ServerT SubmissionAPI BaseContextM
submissionServer = list_GET :<|> list_POST

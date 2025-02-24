module Wizard.Service.Audit.AuditService where

import Control.Monad.Reader (asks, liftIO)
import qualified Data.Map.Strict as M
import Data.Time

import Shared.Util.Uuid
import Wizard.Api.Resource.User.UserDTO
import Wizard.Database.DAO.Audit.AuditDAO
import Wizard.Model.Context.AppContext
import Wizard.Service.Audit.AuditMapper

logAudit :: String -> String -> String -> AppContextM ()
logAudit component action entity = logAuditWithBody component action entity M.empty

logAuditWithBody :: String -> String -> String -> M.Map String String -> AppContextM ()
logAuditWithBody component action entity body = do
  aUuid <- liftIO generateUuid
  appUuid <- asks currentAppUuid
  mCurrentUser <- asks currentUser
  let createdBy = fmap (.uuid) mCurrentUser
  now <- liftIO getCurrentTime
  let audit = toAudit aUuid component action entity body createdBy appUuid now
  insertAudit audit
  return ()

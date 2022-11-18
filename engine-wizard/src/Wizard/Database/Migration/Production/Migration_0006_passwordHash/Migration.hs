module Wizard.Database.Migration.Production.Migration_0006_passwordHash.Migration (
  definition,
) where

import Control.Monad.Logger
import Control.Monad.Reader (liftIO)
import Data.Pool (Pool, withResource)
import Data.String (fromString)
import Database.PostgreSQL.Migration.Entity
import Database.PostgreSQL.Simple

definition = (meta, migrate)

meta =
  MigrationMeta
    { mmNumber = 6
    , mmName = "Password Hash"
    , mmDescription = "Add information if password hash is generated by pbkdf1 or pbkdf2"
    }

migrate :: Pool Connection -> LoggingT IO (Maybe Error)
migrate dbPool = do
  let sql = "UPDATE user_entity SET password_hash = 'pbkdf1:' || password_hash"
  let action conn = execute_ conn (fromString sql)
  liftIO $ withResource dbPool action
  return Nothing

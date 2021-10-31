module Registry.Bootstrap.DatabaseMigration where

import Control.Lens ((^.))

import LensesConfig
import Registry.Bootstrap.Common
import qualified Registry.Database.Migration.Development.Migration as DM
import qualified Registry.Database.Migration.Production.Migration as PM
import Registry.Model.Context.BaseContext
import Shared.Model.Config.Environment

runDBMigrations :: BaseContext -> IO (Maybe String)
runDBMigrations context =
  case context ^. serverConfig . general . environment of
    Development -> runAppContextWithBaseContext DM.runMigration context
    Production -> PM.runMigration context

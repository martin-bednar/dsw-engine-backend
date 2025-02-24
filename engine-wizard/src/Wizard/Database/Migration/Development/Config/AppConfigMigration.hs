module Wizard.Database.Migration.Development.Config.AppConfigMigration where

import Shared.Constant.Component
import Wizard.Database.DAO.Config.AppConfigDAO
import Wizard.Database.Migration.Development.Config.Data.AppConfigs
import Wizard.Util.Logger

runMigration = do
  logInfo _CMP_MIGRATION "(Config/AppConfig) started"
  deleteAppConfigs
  insertAppConfig defaultAppConfigEncrypted
  insertAppConfig differentAppConfigEncrypted
  logInfo _CMP_MIGRATION "(Config/AppConfig) ended"

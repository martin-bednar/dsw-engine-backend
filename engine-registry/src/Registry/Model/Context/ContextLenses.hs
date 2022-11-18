module Registry.Model.Context.ContextLenses where

import qualified Data.Map.Strict as M
import Data.Pool (Pool)
import qualified Data.UUID as U
import Database.PostgreSQL.Simple (Connection)
import GHC.Records
import Network.Minio (MinioConn)

import Registry.Model.Config.ServerConfig
import Registry.Model.Context.AppContext
import Registry.Model.Context.BaseContext
import Registry.Model.Organization.Organization
import Shared.Constant.App
import Shared.Model.Config.BuildInfoConfig
import Shared.Model.Config.ServerConfig

instance HasField "serverConfig'" AppContext ServerConfig where
  getField = (.serverConfig)

instance HasField "serverConfig'" BaseContext ServerConfig where
  getField = (.serverConfig)

instance HasField "s3'" ServerConfig ServerConfigS3 where
  getField = (.s3)

instance HasField "sentry'" ServerConfig ServerConfigSentry where
  getField = (.sentry)

instance HasField "cloud'" ServerConfig ServerConfigCloud where
  getField = (.cloud)

instance HasField "dbPool'" AppContext (Pool Connection) where
  getField = (.dbPool)

instance HasField "dbPool'" BaseContext (Pool Connection) where
  getField = (.dbPool)

instance HasField "dbConnection'" AppContext (Maybe Connection) where
  getField = (.dbConnection)

instance HasField "s3Client'" AppContext MinioConn where
  getField = (.s3Client)

instance HasField "s3Client'" BaseContext MinioConn where
  getField = (.s3Client)

instance HasField "localization'" AppContext (M.Map String String) where
  getField = (.localization)

instance HasField "localization'" BaseContext (M.Map String String) where
  getField = (.localization)

instance HasField "buildInfoConfig'" AppContext BuildInfoConfig where
  getField = (.buildInfoConfig)

instance HasField "buildInfoConfig'" BaseContext BuildInfoConfig where
  getField = (.buildInfoConfig)

instance HasField "identityUuid'" AppContext (Maybe String) where
  getField entity = fmap (.token) entity.currentOrganization

instance HasField "traceUuid'" AppContext U.UUID where
  getField = (.traceUuid)

instance HasField "appUuid'" AppContext U.UUID where
  getField entity = defaultAppUuid

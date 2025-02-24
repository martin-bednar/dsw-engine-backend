module Registry.Specs.API.Package.Common where

import Test.Hspec
import Test.Hspec.Wai hiding (shouldRespondWith)

import Shared.Database.DAO.Package.PackageDAO
import Shared.Model.Package.Package

import Registry.Specs.API.Common

-- --------------------------------
-- ASSERTS
-- --------------------------------
assertExistenceOfPackageInDB appContext package = do
  packageFromDb <- getOneFromDB (findPackageById package.pId) appContext
  comparePackageDtos packageFromDb package

-- --------------------------------
-- COMPARATORS
-- --------------------------------
comparePackageDtos resDto expDto = do
  liftIO $ resDto.pId `shouldBe` expDto.pId
  liftIO $ resDto.name `shouldBe` expDto.name
  liftIO $ resDto.organizationId `shouldBe` expDto.organizationId
  liftIO $ resDto.kmId `shouldBe` expDto.kmId
  liftIO $ resDto.version `shouldBe` expDto.version
  liftIO $ resDto.description `shouldBe` expDto.description
  liftIO $ resDto.previousPackageId `shouldBe` expDto.previousPackageId

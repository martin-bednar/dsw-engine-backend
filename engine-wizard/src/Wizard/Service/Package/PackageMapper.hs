module Wizard.Service.Package.PackageMapper where

import qualified Data.List as L
import qualified Data.UUID as U

import Shared.Api.Resource.Package.PackageDTO
import Shared.Model.Package.Package
import Shared.Model.Package.PackageWithEvents
import Shared.Util.Coordinate
import Wizard.Api.Resource.Package.PackageDetailDTO
import Wizard.Api.Resource.Package.PackageSimpleDTO
import Wizard.Model.Package.PackageList
import Wizard.Model.Package.PackageSuggestion
import Wizard.Model.Registry.RegistryOrganization
import Wizard.Model.Registry.RegistryPackage
import Wizard.Service.Package.PackageUtil

toSimpleDTO :: Package -> PackageSimpleDTO
toSimpleDTO = toSimpleDTO' [] []

toSimpleDTO' :: [RegistryPackage] -> [RegistryOrganization] -> Package -> PackageSimpleDTO
toSimpleDTO' pkgRs orgRs pkg =
  PackageSimpleDTO
    { pId = pkg.pId
    , name = pkg.name
    , organizationId = pkg.organizationId
    , kmId = pkg.kmId
    , version = pkg.version
    , remoteLatestVersion =
        case selectPackageByOrgIdAndKmId pkg pkgRs of
          Just pkgR -> Just $ pkgR.remoteVersion
          Nothing -> Nothing
    , description = pkg.description
    , state = computePackageState pkgRs pkg
    , organization = selectOrganizationByOrgId pkg orgRs
    , createdAt = pkg.createdAt
    }

toSimpleDTO'' :: Bool -> PackageList -> PackageSimpleDTO
toSimpleDTO'' registryEnabled pkg =
  PackageSimpleDTO
    { pId = pkg.pId
    , name = pkg.name
    , organizationId = pkg.organizationId
    , kmId = pkg.kmId
    , version = pkg.version
    , remoteLatestVersion = pkg.remoteVersion
    , description = pkg.description
    , state = computePackageState' registryEnabled pkg
    , organization =
        case pkg.remoteOrganizationName of
          Just orgName ->
            Just $
              RegistryOrganization
                { organizationId = pkg.organizationId
                , name = orgName
                , logo = pkg.remoteOrganizationLogo
                , createdAt = pkg.createdAt
                }
          Nothing -> Nothing
    , createdAt = pkg.createdAt
    }

toDetailDTO :: Package -> [RegistryPackage] -> [RegistryOrganization] -> [String] -> Maybe String -> PackageDetailDTO
toDetailDTO pkg pkgRs orgRs versionLs registryLink =
  PackageDetailDTO
    { pId = pkg.pId
    , name = pkg.name
    , organizationId = pkg.organizationId
    , kmId = pkg.kmId
    , version = pkg.version
    , description = pkg.description
    , readme = pkg.readme
    , license = pkg.license
    , metamodelVersion = pkg.metamodelVersion
    , previousPackageId = pkg.previousPackageId
    , forkOfPackageId = pkg.forkOfPackageId
    , mergeCheckpointPackageId = pkg.mergeCheckpointPackageId
    , versions = L.sort versionLs
    , remoteLatestVersion =
        case selectPackageByOrgIdAndKmId pkg pkgRs of
          Just pkgR -> Just $ pkgR.remoteVersion
          Nothing -> Nothing
    , state = computePackageState pkgRs pkg
    , registryLink = registryLink
    , organization = selectOrganizationByOrgId pkg orgRs
    , createdAt = pkg.createdAt
    }

toSuggestion :: (Package, [String]) -> PackageSuggestion
toSuggestion (pkg, localVersions) =
  PackageSuggestion
    { pId = pkg.pId
    , name = pkg.name
    , version = pkg.version
    , description = pkg.description
    , versions = L.sortBy compareVersion localVersions
    }

fromDTO :: PackageDTO -> U.UUID -> PackageWithEvents
fromDTO dto appUuid =
  PackageWithEvents
    { pId = dto.pId
    , name = dto.name
    , organizationId = dto.organizationId
    , kmId = dto.kmId
    , version = dto.version
    , metamodelVersion = dto.metamodelVersion
    , description = dto.description
    , readme = dto.readme
    , license = dto.license
    , previousPackageId = dto.previousPackageId
    , forkOfPackageId = dto.forkOfPackageId
    , mergeCheckpointPackageId = dto.mergeCheckpointPackageId
    , events = dto.events
    , appUuid = appUuid
    , createdAt = dto.createdAt
    }

buildPackageUrl :: String -> Package -> [RegistryPackage] -> Maybe String
buildPackageUrl clientRegistryUrl pkg pkgRs =
  case selectPackageByOrgIdAndKmId pkg pkgRs of
    Just pkgR ->
      Just $
        clientRegistryUrl
          ++ "/knowledge-models/"
          ++ buildCoordinate pkgR.organizationId pkgR.kmId pkgR.remoteVersion
    Nothing -> Nothing

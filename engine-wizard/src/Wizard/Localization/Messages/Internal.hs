module Wizard.Localization.Messages.Internal where

-- --------------------------------------
-- INTEGRATION
-- --------------------------------------
-- Common
_ERROR_INTEGRATION_COMMON__INT_SERVICE_RETURNED_ERROR message =
  "Integration Service returned an error (" ++ message ++ ")"

-- Response Mappers (Response deserialization problem = RDF)
_ERROR_INTEGRATION_COMMON__RDF_UNABLE_TO_DESERIALIZE_RESPONSE_BODY a =
  "Problem with a response deserialization (unable to deserialize a response body: " ++ a ++ ")"

_ERROR_INTEGRATION_COMMON__RDF_UNABLE_TO_GET_RESPONSE_BODY =
  "Problem with a response deserialization (unable to get a response body)"

_ERROR_INTEGRATION_COMMON__RDF_UNABLE_TO_EXTRACT_NESTED_FIELDS fieldNames =
  "Problem with a response deserialization (unable to extract nested field '" ++ show fieldNames ++ "')"

_ERROR_INTEGRATION_COMMON__RDF_UNABLE_TO_EXTRACT_STRING_FIELD fieldName =
  "Problem with a response deserialization (unable to extract string field: '" ++ fieldName ++ "')"

_ERROR_INTEGRATION_COMMON__RDF_UNABLE_TO_EXTRACT_INTEGER_FIELD fieldName =
  "Problem with a response deserialization (unable to extract integer field: '" ++ fieldName ++ "')"

_ERROR_INTEGRATION_COMMON__RDF_FIELD_IS_NOT_ARRAY = "Problem with a response deserialization (field is not an array)"

-- --------------------------------------
-- SERVICE
-- --------------------------------------
-- Feedback
_ERROR_SERVICE_FEEDBACK__REQUEST_FAILED serviceName endpoint =
  "Request to external API failed (service: '" ++ serviceName ++ "', endpoint: '" ++ endpoint ++ "')"

-- Mail
_MESSAGE_SERVICE_MAIL__APP_TITLE = "Data Stewardship Wizard"

-- Migration / Metamodel
_ERROR_SERVICE_MIGRATION_METAMODEL__FAILED_TO_MIGRATE_ENTITIES entityName = "Failed to migrate '" ++ entityName ++ "'"

_ERROR_SERVICE_MIGRATION_METAMODEL__FAILED_CONVERT_TO_NEW_METAMODEL entityName =
  "Failed to convert entity ('" ++ entityName ++ "') to new metamodel"

-- Questionnaire
_ERROR_SERVICE_QTN__INVITATION_EMAIL_NOT_SENT =
  "The questionnaire invitation email could not be sent. Please contact administrator."

-- Template
_ERROR_SERVICE_TEMPLATE__LOADING_TEMPLATE_FAILED reason = "Couldn't load a template from file (" ++ reason ++ ")"

_ERROR_SERVICE_TEMPLATE__NO_TEMPLATES_IN_SYSTEM = "There are no specified templates in the system."

-- Token
_ERROR_SERVICE_TOKEN__UNABLE_TO_GET_TOKEN = "Unable to get token"

-- User
_ERROR_SERVICE_USER__ACTIVATION_EMAIL_NOT_SENT = "The activation email could not be sent. Please contact administrator."

_ERROR_SERVICE_USER__RECOVERY_EMAIL_NOT_SENT = "The recovery email could not be sent. Please contact administrator."

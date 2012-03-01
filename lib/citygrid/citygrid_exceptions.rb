module CityGridExceptions

  # Define parent error classes
  # All errors thrown in the API should extend APIError - Level 1
  class APIError < StandardError
    attr_accessor :request
    
    def initialize request, response, msg = "An API error occurred"
      super msg
    end
  end

  # Level 2 - These represent three different error scenarios:
  # 1.  Response is totally not parsable to JSON
  # 2.  The API call/parameters were malformed
  # 3.  The request was fine but their was an error API side

  class ResponseParseError < APIError
    attr_accessor :server_msg, :description, :raw_response
    def initialize request, response, msg = nil
      self.raw_response = response
      # parse Tomcat error report
      if response.match /<title>Apache Tomcat.* - Error report<\/title>/
        response.scan(/<p><b>(message|description)<\/b> *<u>(.*?)<\/u><\/p>/).each do |match|
          case match[0]
          when "message"
            self.server_msg = match[1]
          when "description"
            self.description = match[1]       
          end
        end

        error_body = response.match(/<body>(.*?)<\/body>/m)[1]

        msg = <<-EOS
        Unexpected response format. Expected response to be a hash, but was instead:\n#{error_body}\n
        EOS

        super msg, request
      else
        msg = <<-EOS
        Unexpected response format. Expected response to be a hash, but was instead:\n#{response.parsed_response}\n
        EOS

        super msg, request
      end
    end
  end

  class RequestError < APIError
    attr_accessor :inner_exception
    
    def initialize request, response, msg = nil
      self.inner_exception = inner_exception
      self.request = request
      super msg, request
      #super msg || "Error while performing request: #{inner_exception.message}", request
    end
  end

  class ResponseError < APIError
    attr_accessor :errors, :response
    
    def initialize request, errors, response
      self.errors = errors
      self.response = response
      
      super "API returned error message", request
    end
  end

  # Level 3
  class GeneralError < APIError; end
  class HeaderError < APIError; end
  class AuthenticationError < APIError; end
  class AuthorizationError < APIError; end
  class OperatorError < RequestError; end
  class GeneralDataError < APIError; end
  class SpecificDataError < APIError; end

  # Level 4

  # General Errors
  class SystemErrorTryAgainError < GeneralError; end
  class SystemErrorUnknownError < GeneralError; end
  class BadRequestTypeError < GeneralError; end 



  # HeaderErrors < RequestError
  class ContentTypeRequiredError < HeaderError; end
  class ContentTypeInvalidError < HeaderError; end
  class AcceptRequiredError < HeaderError; end 
  class AcceptInvalidError < HeaderError; end

  # Authentication Error
  class AuthTokenInvalidError < AuthenticationError; end
  class AuthTokenExpiredError < AuthenticationError; end
  class AuthTokenNoneError    < AuthenticationError; end
  class UsernameRequiredError < AuthenticationError; end
  class PasswordRequiredError < AuthenticationError; end
  class AccountNotFoundError  < AuthenticationError; end

 #Authorization Error
 class PermissionDeniedError < AuthorizationError; end
 class NoPermissionsError < AuthorizationError; end

 # Request Error
 class ParameterRequiredError            < RequestError; end
 class ParameterRequiredConditionalError < RequestError; end
 class ParameterInvalidError             < RequestError; end
 class ParameterFormatError              < RequestError; end
 class ParameterNotSupportedError        < RequestError; end
 class ParameterRangeTooLowError         < RequestError; end
 class ParameterRangeTooHighError        < RequestError; end
 class ParameterSizeLimitExceededError   < RequestError; end
 class ParameterCannotBeZeroError        < RequestError; end
 class ParameterOnlyOne                  < RequestError; end

 # Operator Error
 class OperatorInvalidError < OperatorError; end

 # General Data Errors
 class EntityNotFoundError      < GeneralDataError; end
 class EntityExistsError        < GeneralDataError; end
 class EntityLimitError         < GeneralDataError; end
 class EntityAlreadyInUseError  < GeneralDataError; end
 class EntityExpiredError       < GeneralDataError; end
 class EntityInactiveError      < GeneralDataError; end
 class EntityNotEligibleError   < GeneralDataError; end
 class EntityNotModifiedError   < GeneralDataError; end
 class EntityStateInvalidError  < GeneralDataError; end
 class EntityMissingDataError   < GeneralDataError; end
 class DataNotFoundError        < GeneralDataError; end
 class AssociationExistsError   < GeneralDataError; end
 class NoAssociationExistsError < GeneralDataError; end
 class DuplicateError           < GeneralDataError; end
 class DateBeforeDateError      < GeneralDataError; end
 class RemoveNotAllowedError    < GeneralDataError; end

#data errors - specific
 class MopExpiredError           < SpecificDataError; end
 class AccountInactiveError      < SpecificDataError; end
 class AccountDelinquentError    < SpecificDataError; end
 class MonthlyBudgetReachedError < SpecificDataError; end
 class QuotaExceededError        < SpecificDataError; end
 class RateExceededError         < SpecificDataError; end

# unused errors
#400 => RequestError,
@possible_errors =
 { 
  0 => ResponseError, nil => ResponseParseError, "" => ResponseParseError, 
  401 => AuthenticationError, 403 => RequestError, 405 => RequestError, 406 => HeaderError, 
  500 => ResponseError, "SYSTEM_ERROR_TRY_AGAIN" => SystemErrorTryAgainError,
  "SYSTEM_ERROR_UNKNOWN" => SystemErrorUnknownError, "BAD_REQUEST_TYPE" => BadRequestTypeError,
  "HEADER_CONTENT_TYPE_IS_REQUIRED" => ContentTypeRequiredError, "HEADER_CONTENT_TYPE_INVALID" => ContentTypeInvalidError,
  "HEADER_ACCEPT_IS_REQUIRED" => AcceptRequiredError, "HEADER_ACCEPT_INVALID" => AcceptInvalidError,
  "AUTH_TOKEN_INVALID" => AuthTokenInvalidError, "AUTH_TOKEN_EXPIRED" => AuthTokenExpiredError,
  "AUTH_TOKEN_NONE" => AuthTokenNoneError,
  "USERNAME_IS_REQUIRED" => UsernameRequiredError, "PASSWORD_IS_REQUIRED" => PasswordRequiredError,
  "ACCOUNT_NOT_FOUND" => AccountNotFoundError, "PERMISSION_DENIED" => PermissionDeniedError,
  "NO_PERMISSIONS" => NoPermissionsError, "PARAMETER_REQUIRED" => ParameterRequiredError,
  "PARAMETER_REQUIRED_CONDITIONAL" => ParameterRequiredConditionalError, "PARAMETER_INVALID" => ParameterInvalidError,
  "PARAMETER_FORMAT" => ParameterFormatError, "PARAMETER_NOT_SUPPORTED" => ParameterNotSupportedError,
  "PARAMETER_RANGE_TOO_LOW" => ParameterRangeTooLowError, "PARAMETER_RANGE_TOO_HIGH" => ParameterRangeTooHighError,
  "PARAMETER_SIZE_LIMIT_EXCEEDED" => ParameterSizeLimitExceededError, "PARAMETER_CANNOT_BE_ZERO" => ParameterCannotBeZeroError,
  "PARAMETER_ONLY_ONE" => ParameterOnlyOne, "OPERATOR_INVALID" => OperatorInvalidError,
  "ENTITY_NOT_FOUND" => EntityNotFoundError, "ENTITY_EXISTS" => EntityExistsError,
  "ENTITY_LIMIT" => EntityLimitError, "ENTITY_ALREADY_IN_USE" => EntityAlreadyInUseError,
  "ENTITY_EXPIRED" => EntityExpiredError, "ENTITY_INACTIVE" => EntityInactiveError,
  "ENTITY_NOT_ELIGIBLE" => EntityNotEligibleError, "ENTITY_NOT_MODIFIED" => EntityNotModifiedError,
  "ENTITY_STATE_INVALID" => EntityStateInvalidError, "ENTITY_MISSING_DATA" => EntityMissingDataError,
  "DATA_NOT_FOUND" => DataNotFoundError, "ASSOCIATION_EXISTS" => AssociationExistsError,
  "NO_ASSOCIATION_EXISTS" =>  NoAssociationExistsError, "DUPLICATE" =>  DuplicateError,
  "DATE_BEFORE_DATE" => DateBeforeDateError, "REMOVE_NOT_ALLOWED" => RemoveNotAllowedError,
  "MOP_EXPIRED" => MopExpiredError, "ACCOUNT_INACTIVE" => AccountInactiveError,
  "ACCOUNT_DELINQUENT" => AccountDelinquentError, "MONTHLY_BUDGET_REACHED" => MonthlyBudgetReachedError,
  "QUOTA_EXCEEDED" => QuotaExceededError,"RATE_EXCEEDED" =>  RateExceededError
  }

  def CityGridExceptions.appropriate_error error_code
    if @possible_errors.include?(error_code)
      return @possible_errors[error_code]
    else
      return APIError
    end
  end

  def CityGridExceptions.print_superclasses error_code
    begin
      raise appropriate_error[error_code]
    rescue => ex
      class_hierarchy = ex.class.ancestors
      class_hierarchy.slice!(class_hierarchy.index(StandardError)..-1)
      return class_hierarchy.reverse.join("::")
    end
  end
end
require 'active_support'
require './app/api/concerns/api_request_parameter_converter.rb'
require './app/api/concerns/authorizable.rb'
require './app/api/concerns/api_error_handler.rb'
module APIExtensions
  extend ActiveSupport::Concern

  included do
    include APIErrorHandler
    # include APIRequestParameterConverter
    # include APIRequestParameterLogger
    include Authorizable
  end
  
end

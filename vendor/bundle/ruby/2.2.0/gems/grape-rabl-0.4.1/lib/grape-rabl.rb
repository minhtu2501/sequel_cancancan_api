require 'rabl'
require 'grape'
require 'hashie/hash'
require 'grape/rabl'
require 'grape-rabl/tilt'
require 'grape-rabl/version'
require 'grape-rabl/formatter'
require 'grape-rabl/render'
require 'grape-rabl/configuration'

module Grape
  module Rabl
    class << self
      def configure(&block)
        yield(configuration)
        configuration
      end

      def configuration
        @configuration ||= Configuration.new
      end

      def reset_configuration!
        @configuration = nil
      end
    end
  end
end

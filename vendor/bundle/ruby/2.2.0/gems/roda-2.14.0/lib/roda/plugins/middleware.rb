# frozen-string-literal: true

#
class Roda
  module RodaPlugins
    # The middleware plugin allows the Roda app to be used as
    # rack middleware.
    #
    # In the example below, requests to /mid will return Mid
    # by the Mid middleware, and requests to /app will not be
    # matched by the Mid middleware, so they will be forwarded
    # to App.
    #
    #   class Mid < Roda
    #     plugin :middleware
    #
    #     route do |r|
    #       r.is "mid" do
    #         "Mid"
    #       end
    #     end
    #   end
    #
    #   class App < Roda
    #     use Mid
    #
    #     route do |r|
    #       r.is "app" do
    #         "App"
    #       end
    #     end
    #   end
    #
    #   run App
    #
    # It is possible to use the Roda app as a regular app even when using
    # the middleware plugin.
    module Middleware
      # Configure the middleware plugin.  Options:
      # :env_var :: Set the environment variable to use to indicate to the roda
      #             application that the current request is a middleware request.
      #             You should only need to override this if you are using multiple
      #             roda middleware in the same application.
      def self.configure(app, opts={})
        app.opts[:middleware_env_var] = opts[:env_var] if opts.has_key?(:env_var)
        app.opts[:middleware_env_var] ||= 'roda.forward_next'
      end

      # Forward instances are what is actually used as middleware.
      class Forwarder
        # Store the current middleware and the next middleware to call.
        def initialize(mid, app)
          @mid = mid
          @app = app
        end

        # When calling the middleware, first call the current middleware.
        # If this returns a result, return that result directly.  Otherwise,
        # pass handling of the request to the next middleware.
        def call(env)
          res = nil

          call_next = catch(:next) do
            env[@mid.opts[:middleware_env_var]] = true
            res = @mid.call(env)
            false
          end

          if call_next
            @app.call(env)
          else
            res
          end
        end
      end

      module ClassMethods
        # Create a Forwarder instead of a new instance if a non-Hash is given.
        def new(app)
          if app.is_a?(Hash)
            super
          else
            Forwarder.new(self, app)
          end
        end

        # Override the route block so that if no route matches, we throw so
        # that the next middleware is called.
        def route(*args, &block)
          super do |r|
            res = instance_exec(r, &block)
            throw :next, true if r.forward_next
            res
          end
        end
      end

      module RequestMethods
        # Whether to forward the request to the next application.  Set only if
        # this request is being performed for middleware.
        def forward_next
          env[roda_class.opts[:middleware_env_var]]
        end
      end
    end

    register_plugin(:middleware, Middleware)
  end
end

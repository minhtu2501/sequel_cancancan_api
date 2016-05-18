# frozen-string-literal: true

#
class Roda
  module RodaPlugins
    # The symbol_matchers plugin allows you do define custom regexps to use
    # for specific symbols.  For example, if you have a route such as:
    #
    #   r.on :username do
    #     # ...
    #   end
    #
    # By default this will match all nonempty segments.  However, if your usernames
    # must be 6-20 characters, and can only contain +a-z+ and +0-9+, you can do:
    #
    #   plugin :symbol_matchers
    #   symbol_matcher :username, /([a-z0-9]{6,20})/
    #
    # Then the route will only if the path is +/foobar123+, but not if it is
    # +/foo+, +/FooBar123+, or +/foobar_123+.
    #
    # Note that this feature does not apply to just symbols, but also to
    # embedded colons in strings, so the following:
    #
    #   r.on "users/:username" do
    #     # ...
    #   end
    #
    # Would match +/users/foobar123+, but not +/users/foo+, +/users/FooBar123+,
    # or +/users/foobar_123+.
    #
    # By default, this plugin sets up the following symbol matchers:
    #
    # :d :: <tt>/(\d+)/</tt>, a decimal segment
    # :format :: <tt>/(?:\.(\w+))?/</tt>, an optional format/extension
    # :opt :: <tt>/(?:\/([^\/]+))?</tt>, an optional segment
    # :optd :: <tt>/(?:\/(\d+))?</tt>, an optional decimal segment
    # :rest :: <tt>/(.*)/</tt>, all remaining characters, if any
    # :w :: <tt>/(\w+)/</tt>, a alphanumeric segment
    #
    # Note that because of how segment matching works, :format, :opt, and :optd
    # are only going to work inside of a string, like this:
    #
    #   r.is "album:opt" do |id| end
    #   # matches /album (yielding nil) and /album/foo (yielding "foo")
    #   # does not match /album/ or /album/foo/bar
    #
    # If using this plugin with the params_capturing plugin, this plugin should
    # be loaded first.
    module SymbolMatchers
      def self.configure(app)
        app.symbol_matcher(:d, /(\d+)/)
        app.symbol_matcher(:format, /(?:\.(\w+))?/)
        app.symbol_matcher(:opt, /(?:\/([^\/]+))?/)
        app.symbol_matcher(:optd, /(?:\/(\d+))?/)
        app.symbol_matcher(:rest, /(.*)/)
        app.symbol_matcher(:w, /(\w+)/)
      end

      module ClassMethods
        # Set the regexp to use for the given symbol, instead of the default.
        def symbol_matcher(s, re)
          self::RodaRequest.send(:define_method, :"match_symbol_#{s}"){re}
        end
      end

      module RequestMethods
        private

        # Use regular expressions to the symbol-specific regular expression
        # if the symbol is registered.  Otherwise, call super for the default
        # behavior.
        def _match_symbol(s)
          meth = :"match_symbol_#{s}"
          if respond_to?(meth)
            re = send(meth)
            consume(self.class.cached_matcher(re){re})
          else
            super
          end
        end

        # Return the symbol-specific regular expression if one is registered.
        # Otherwise, call super for the default behavior.
        def _match_symbol_regexp(s)
          meth = :"match_symbol_#{s}"
          if respond_to?(meth)
            send(meth)
          else
            super
          end
        end
      end
    end

    register_plugin(:symbol_matchers, SymbolMatchers)
  end
end

require 'active_support'
require './app/errors/unauthorized.rb'
module Authorizable 
  extend ActiveSupport::Concern
  included do
    helpers do
      def authentication?
        fail Unauthorized unless current_user
      end

      def current_user
        token = ApiKey.find(access_token: headers['Access-Token'])
          unless token && !token.expired?
          false
        else
          @user = User[token.user_id]
        end
      end
    end
  end
end
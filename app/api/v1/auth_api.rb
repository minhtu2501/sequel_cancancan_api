module V1
  class AuthAPI < Grape::API
    helpers do
      def new_request_info
        Hash[ip: request.ip, user_agent: request.user_agent]
      end
    end

    resource :auth do
      desc "login/auth"
      post "/login", rabl: 'auth/login' do
        binding.pry
        if params[:email].blank? || params[:password].blank?
          {meta:{status: :failed, code: 500, messages: "Signin successfully" },data: nil}
        else
          @user = User.find(email: params[:email].downcase)
          if @user.password == params[:password]
            # Create token
            token = ApiKey.find(user_id: @user.id)
            new_token = token.generate_access_token
            token.save()
            @user
            binding.pry
          else
            {meta:{status: :failed, code: 500, messages: I18n.t('errors.messages.wrong_user_pass')},data: nil}
          end
        end
      end

      desc "logout/auth"
      delete "/logout" do
        authentication?
        if @user
          @user.log_out
          # $redis.srem("session_user: #{@user.id}", new_request_info)
          {"meta":{"status":"successfully", "code":200, "message":"Logout successfully"}}
        end
      end
    end
  end
end
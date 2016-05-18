#!/usr/bin/ruby

module V1
  class UserAPI < Grape::API
    helpers do
      def authorize!(*args)
      # you already implement current_user helper :)
      authentication?
      ::Ability.new(@user).authorize!(*args)
      end
    end
    
    resource :users do 

      desc "index/users"
      get "/", rabl: 'users/index' do
        authorize! :index, :users
        @users = User.all
      end

      desc "show/users"
      get "/:id", rabl: 'users/show' do
        authorize! :show, :users
        @user = User[params[:id]] if params[:id]
      end

      desc "new/users"
      post "/sign_up" do
        binding.pry
        if params[:name].blank? || params[:email].blank? || params[:password].blank?
          # error!({meta:{status: :failed, code: 500, messages: I18n.t('errors.messages.blank_user_pass') },data: nil})
        else
          if @user = User.create(name: params[:name], email: params[:email], password: params[:password])
            binding.pry
            @api_key = ApiKey.new
            @api_key.user_id = @user.id
            @api_key.save
            @user
          else
            # error!({meta:{status: :failed, code: 500, messages: 'Cannot create new User.' },data: nil})
          end           
        end
      end

      desc "edit/users"
      get "/:id/edit", rabl: 'users/edit' do
        authorize! :edit, :users
        @user = User.find(params[:id]) if params[:id]
        # @roles = Role.all
        # @user_roles = @user.roles.collect{|r| r.id}
      end

      desc "update/users"
      put "/", rabl: 'users/update' do
        authorize! :update, :users
        @user = User.find(params[:id]) if params[:id]
        @user.roles = []
        @role.set_roles(params[:permissions]) if params[:permissions]
        if @user.save
          {"meta":{"status":"successfully", "code":200, "message":"Update roles successfully"}}
        else
          error!({meta:{status: :failed, code: 500, messages: 'Cannot update role.' },data: nil})
        end
      end
    end
  end
end
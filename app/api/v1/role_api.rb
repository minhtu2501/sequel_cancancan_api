module V1
  class RoleAPI < Grape::API
    helpers do
      def authorize!(*args)
      # you already implement current_user helper :)
      authentication?
      ::Ability.new(@user).authorize!(*args)
      end
    end
    resource :roles do
      desc "index/roles"
      get "/", rabl: "roles/index" do
        authorize! :index, :roles
        @roles = Role.all 
      end

      desc "show/roles"
      get "/:id", rabl: "roles/show" do
        authorize! :show, :roles
        @role = Role.find(params[:id]) if params[:id]
      end

      desc "create/roles"
      post "/", rabl: "roles/new" do
        authorize! :create, :roles
        @role = Role.create(name: params[:name])
      end

      desc "edit/roles"
      get "/:id/edit", rabl: "roles/edit" do
        authorize! :edit, :roles
        @role = Role.find(params[:id]) if params[:id]
        # @permissions = @role.permissions
      end

      desc "update/roles"
      get "/" do
        @role = Role.find(params[:id]) if params[:id]
        @role.permissions = []
        @role.set_permissions(params[:permissions]) if params[:permissions]
        if @role.save
          {"meta":{"status":"successfully", "code":200, "message":"Update roles successfully"}}
        else
          error!({meta:{status: :failed, code: 500, messages: 'Cannot update role.' },data: nil})
        end
      end
    end
  end
end
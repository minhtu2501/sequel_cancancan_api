namespace :db do
  desc "Get all permissions"
  task permissions: :app do
    require "./app/api/root_v1"
    require './app/models/permission'
    RootV1.routes.each do |route|
      resource = route.app.options[:route_options][:description]
      a = resource.split("/") 
      write_permission(a[0], a[1])
    end
  end

  desc "DB seed"
  task seed: :app do
    require './app/models/permissions_role'
    require './app/models/permissions_user'
    require './app/models/roles_user'
    require './app/models/permission'

    Permission.create(action: 'manage', subject_class: 'all')
    RolesUser.create(role_id: 5, user_id: 14)
    PermissionsRole.create(role_id: 5, permission_id: 1)
    PermissionsRole.create(role_id: 5, permission_id: 2)
    PermissionsRole.create(role_id: 5, permission_id: 3)
    
  end

  def write_permission(cancan_action, subject_class)
    permission  = Permission.find(action: cancan_action, subject_class: subject_class)
    unless permission
      permission = Permission.create(action: cancan_action, subject_class: subject_class)
    end
  end
end
require 'sequel'
DB = Sequel.connect('postgres://postgres:123456@localhost:5432/grape-sequel_development')

Sequel::Model.plugin :schema

class Permission < Sequel::Model
  one_to_many :permissons_users
  one_to_many :permissons_roles
  many_to_many :users, left_key: :permission_id, right_key: :user_id,
                                              join_table: :permissions_users
  many_to_many :roles, left_key: :permission_id, right_key: :role_id,
                                              join_table: :permissions_roles
  Sequel.extension :pagination
end
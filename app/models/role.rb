require 'sequel'
DB = Sequel.connect('postgres://postgres:123456@localhost:5432/grape-sequel_development')

Sequel::Model.plugin :schema

class Role < Sequel::Model
  one_to_many :roles_users
  one_to_many :permissions_roles
  many_to_many :users, left_key: :role_id, right_key: :user_id,
                                              join_table: :roles_users
  many_to_many :permissions, left_key: :role_id, right_key: :permission_id,
                                              join_table: :permissions_roles
end
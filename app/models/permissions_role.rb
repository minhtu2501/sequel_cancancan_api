require 'sequel'
DB = Sequel.connect('postgres://postgres:123456@localhost:5432/grape-sequel_development')

Sequel::Model.plugin :schema

class PermissionsRole < Sequel::Model
  many_to_one :permission
  many_to_one :role
  Sequel.extension :pagination
end
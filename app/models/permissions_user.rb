require 'sequel'
DB = Sequel.connect('postgres://postgres:123456@localhost:5432/grape-sequel_development')

Sequel::Model.plugin :schema

class PermissionsUser < Sequel::Model
  many_to_one :permission
  many_to_one :user
  Sequel.extension :pagination
end
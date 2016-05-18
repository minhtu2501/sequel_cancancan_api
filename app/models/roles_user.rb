require 'sequel'
DB = Sequel.connect('postgres://postgres:123456@localhost:5432/grape-sequel_development')

Sequel::Model.plugin :schema

class RolesUser < Sequel::Model
  many_to_one :role
  many_to_one :user
  Sequel.extension :pagination
end
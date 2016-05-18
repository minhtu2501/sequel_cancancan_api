require 'sequel'
require 'bcrypt'
DB = Sequel.connect('postgres://postgres:123456@localhost:5432/grape-sequel_development')

Sequel::Model.plugin :schema

class User < Sequel::Model
  include BCrypt
  one_to_one :api_key
  one_to_many :permissions_users
  one_to_many :roles_users
  many_to_many :roles, left_key: :user_id, right_key: :role_id,
                                              join_table: :roles_users
  many_to_many :permissions, left_key: :user_id, right_key: :permission_id,
                                              join_table: :permissions_users
  Sequel.extension :pagination

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def log_out
    binding.pry
    token = self.api_key
    token.access_token = Digest::MD5.hexdigest("#{Time.now.to_i.to_s}
      #{SecureRandom.hex}
      #{self.id}
      log_out")
    token.save()
  end

  # def set_roles(roles)
  #   roles.each do |role_id|
  #     role = Role.find(role_id)
  #     self.permissions << permission
  #   end
  # end
end
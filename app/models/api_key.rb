require 'sequel'
DB = Sequel.connect('postgres://postgres:123456@localhost:5432/grape-sequel_development')

Sequel::Model.plugin :schema

class ApiKey < Sequel::Model
  one_to_one :user

  # scope :scope_access_token, -> (token) {where(access_token: token)}

  def expired?
    DateTime.now >= self.expires_at
  end

  def before_create
    super
    generate_access_token
    set_time_expired
  end
  
  def generate_access_token
    self.access_token = Digest::MD5.hexdigest("#{Time.now.to_i.to_s}
      #{SecureRandom.hex}
      #{self.user_id}
      login")
  end


  private
  
  def set_time_expired
    self.expires_at = DateTime.now + 30
  end
end
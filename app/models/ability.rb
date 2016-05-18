require 'cancancan'
class Ability
  include CanCan::Ability

  def initialize(user)
    permissions = []
    user.roles.each do |role|
        role.permissions.each do |per|
            permissions << per
        end
    end
    user.permissions.each do |per|
        permissions << per
    end
    if permissions.present?
      permissions = permissions.uniq
      permissions.each do |permission|
        can permission.action.to_sym, permission.subject_class.to_sym
      end
    end
  end
end
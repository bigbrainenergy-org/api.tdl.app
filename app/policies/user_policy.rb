class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def time_zone?
    user.present?
  end

  def update_time_zone?
    user.present?
  end
end

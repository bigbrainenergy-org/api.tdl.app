class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def show?
    return false unless user.present? && record.present?

    user == record
  end

  def update?
    return false unless user.present? && record.present?

    user == record
  end
end

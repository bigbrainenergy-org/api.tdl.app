class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      # FIXME: This seems a bit dumb
      scope.where(id: user&.id)
    end
  end

  def permitted_attributes
    [:locale, :time_zone]
  end

  def permitted_attributes_for_change_password
    [:password]
  end

  def show?
    return false unless user.present? && record.present?

    user == record
  end

  def update?
    return false unless user.present? && record.present?

    user == record
  end

  def change_password?
    update?
  end
end

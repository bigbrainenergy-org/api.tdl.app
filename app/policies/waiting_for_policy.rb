class WaitingForPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def permitted_attributes
    [
      :title,
      :notes,
      :order,
      :next_checkin_at,
      :delegated_to,
      :completed
    ]
  end

  def index?
    user.present?
  end

  def show?
    user_owns_record?
  end

  def create?
    user_owns_record?
  end

  def update?
    user_owns_record?
  end

  def destroy?
    user_owns_record?
  end
end

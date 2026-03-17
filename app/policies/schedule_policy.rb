class SchedulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def permitted_attributes
    [
      :title,
      :default,
      { blocks: [:day_of_week, :start, :end] }
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

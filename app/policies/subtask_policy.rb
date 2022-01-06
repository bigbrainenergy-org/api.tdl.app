class SubtaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.includes(:next_action).where(next_action: { user: user })
    end
  end

  def permitted_attributes
    [:title]
  end

  def index?
    user.present?
  end

  def show?
    user_owns_subtask?
  end

  def create?
    user_owns_subtask?
  end

  def update?
    user_owns_subtask?
  end

  def destroy?
    user_owns_subtask?
  end

  private

  def user_owns_subtask?
    return false unless record&.next_action.present? && user.present?

    user.owner_of?(record.next_action)
  end
end

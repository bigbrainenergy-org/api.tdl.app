class SubtaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:task => :list).where(tasks: { lists: { user_id: user&.id } })
    end
  end

  def permitted_attributes
    [:title, :completed, :order]
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
    return false unless record&.task&.list.present? && user.present?

    user.owner_of?(record.task.list)
  end
end

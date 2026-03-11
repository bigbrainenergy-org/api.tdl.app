class TaskDependencyPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(pre: :list).where(tasks: { lists: { user_id: user&.id } })
    end
  end

  def permitted_attributes_for_create
    [
      :first_id,
      :second_id,
      :degree,
      :notes
    ]
  end

  def permitted_attributes_for_update
    [
      :degree,
      :notes
    ]
  end

  def index?
    user.present?
  end

  def show?
    user_owns_task_dependency?
  end

  def create?
    user_owns_task_dependency?
  end

  def update?
    user_owns_task_dependency?
  end

  def destroy?
    user_owns_task_dependency?
  end

  private

  def user_owns_task_dependency?
    return false unless record&.pre&.list.present? && record&.post&.list.present? && user.present?

    user.owner_of?(record.pre.list) && user.owner_of?(record.post.list)
  end
end

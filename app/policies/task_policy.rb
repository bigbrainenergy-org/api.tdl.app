class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.includes(:list).where(lists: { user_id: user&.id })
    end
  end

  def permitted_attributes
    [
      :context_id,
      :project_id,
      :title,
      :notes,
      :remind_me_at,
      :mental_energy_required,
      :physical_energy_required,
      hard_prereq_ids: [],
      hard_postreq_ids: []
    ]
  end

  def index?
    user.present?
  end

  def show?
    user_owns_task?
  end

  def create?
    user_owns_task?
  end

  def update?
    user_owns_task?
  end

  def destroy?
    user_owns_task?
  end

  private

  def user_owns_task?
    return false unless record&.list.present? && user.present?

    user.owner_of?(record.list)
  end
end

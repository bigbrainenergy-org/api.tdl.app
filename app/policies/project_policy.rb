class ProjectPolicy < ApplicationPolicy
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
      :superproject_ids,
      :subproject_ids,
      :hard_prereq_ids,
      :hard_postreq_ids
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

  def sync_ordering?
    user.present?
  end
end

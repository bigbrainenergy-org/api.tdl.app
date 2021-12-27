class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def permitted_attributes
    [:title, :order]
  end

  def index?
    user.present?
  end

  def show?
    user.owner_of?(record)
    record_user_matches?
  end

  def create?
    record_user_matches?
  end

  def update?
    record_user_matches?
  end

  def destroy?
    record_user_matches?
  end

  def sync_ordering?
    user.present?
  end
end

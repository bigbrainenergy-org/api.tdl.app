class ListPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    user.present?
  end

  def show?
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

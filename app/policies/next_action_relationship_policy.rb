class NextActionRelationshipPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.includes(:first).where(first: { user: user })
    end
  end

  def index?
    user.present?
  end

  def show?
    first_and_second_users_match?
  end

  def create?
    first_and_second_users_match?
  end

  def update?
    first_and_second_users_match?
  end

  def destroy?
    first_and_second_users_match?
  end

  private

  # rubocop:disable Metrics/AbcSize
  def first_and_second_users_match?
    return false unless record.present? && user.present?
    return false unless record.first.present? && record.second.present?

    (
      record.first.user == record.second.user &&
      user.owner_of?(record.first) &&
      user.owner_of?(record.second)
    )
  end
  # rubocop:enable Metrics/AbcSize
end

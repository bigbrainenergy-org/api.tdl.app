class RulePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.includes(:pre).where(pre: { user: user })
    end
  end

  def index?
    user.present?
  end

  def show?
    record_user_matches? && pre_and_post_user_matches?
  end

  def create?
    record_user_matches? && pre_and_post_user_matches?
  end

  def update?
    record_user_matches? && pre_and_post_user_matches?
  end

  def destroy?
    record_user_matches? && pre_and_post_user_matches?
  end

  def pre_and_post_user_matches?
    return false unless record.present? && user.present?
    return false unless record.pre.present? && record.post.present?

    record.pre.user == record.post.user
  end

  # rubocop:disable Metrics/AbcSize
  def record_user_matches?
    return false unless record.present? && user.present?
    return false unless record.pre.present? && record.post.present?

    (
      record.pre.user == user &&
      record.post.user == user
    )
  end
  # rubocop:enable Metrics/AbcSize
end

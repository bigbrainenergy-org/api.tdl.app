class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end

  def index?
    user.present?
  end

  def show?
    matching_records?
  end

  def create?
    matching_records?
  end

  def update?
    matching_records?
  end

  def destroy?
    matching_records?
  end

  # FIXME: There should never be this many non-CRUD methods

  def clear_completed?
    index?
  end

  def bulk?
    index?
  end

  def sync_ordering?
    index?
  end

  def mark_complete?
    update?
  end

  def mark_incomplete?
    update?
  end

  def update_tags?
    update?
  end

  def update_list?
    update?
  end

  def add_prerequisite?
    update?
  end

  def add_postrequisite?
    update?
  end

  def remove_prerequisite?
    update?
  end

  def remove_postrequisite?
    update?
  end

  def list_user_matches?
    return false unless record.present? && user.present?
    return false if record.list.blank?

    record.list.user == user
  end

  def matching_records?
    record_user_matches? && list_user_matches?
  end
end

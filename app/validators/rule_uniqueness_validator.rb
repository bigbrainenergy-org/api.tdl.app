class RuleUniquenessValidator < ActiveModel::Validator
  def validate(record)
    return unless record.pre.present? && record.post.present?
    return unless record.pre.persisted? && record.post.persisted?
    return unless Rule.exists?(pre: record.pre, post: record.post)

    record.errors.add(:base, I18n.t('validators.rule.duplicate_rule'))
  end
end

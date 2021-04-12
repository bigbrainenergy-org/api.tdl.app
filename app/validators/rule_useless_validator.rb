class RuleUselessValidator < ActiveModel::Validator
  def validate(record)
    return unless record.pre == record.post

    record.errors.add(:base, I18n.t('validators.rule.pre_and_post_cant_be_same'))
  end
end

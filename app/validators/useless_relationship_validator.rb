class UselessRelationshipValidator < RelationshipValidator
  def validate(record)
    return unless record.try(@first) == record.try(@second)

    record.errors.add(:base, I18n.t('validators.useless_relationship.invalid'))
  end
end

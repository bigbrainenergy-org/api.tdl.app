class UniqueRelationshipValidator < RelationshipValidator
  def validate(record)
    return unless relationship_persisted?(record)
    return unless record.class.exists?(@first => record.try(@first),
      @second => record.try(@second))

    record.errors.add(:base, I18n.t('validators.unique_relationship.invalid'))
  end
end

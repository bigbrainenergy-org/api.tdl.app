class UniqueRelationshipValidator < RelationshipValidator
  def validate(record)
    return unless relationship_persisted?(record)

    scope = record.class.where(@first => record.try(@first), @second => record.try(@second))
    scope = scope.where.not(id: record.id) if record.persisted?
    return unless scope.exists?

    record.errors.add(:base, I18n.t('validators.unique_relationship.invalid'))
  end
end

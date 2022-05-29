class RedundantRelationshipValidator < RelationshipValidator
  def validate(record)
    return unless relationship_persisted?(record)

    if record.try(@second).try(@all_firsts)&.include?(@first)
      I18n.t(
        'validators.redundant_relationship.invalid',
        first_title: @first,
        second_title: @second,
        relationship: @first
      )
    end

    if record.try(@first).try(@all_seconds)&.include?(@second)
      I18n.t(
        'validators.redundant_relationship.invalid',
        first_title: @second,
        second_title: @first,
        relationship: @second
      )
    end
  end
end

class RedundantRelationshipValidator < RelationshipValidator
  # rubocop:disable Metrics/MethodLength
  def validate(record)
    return unless relationship_persisted?(record)

    if record.try(@second).try(@all_firsts)&.include?(record.try(@first))
      record.errors.add(
        :base,
        I18n.t(
          'validators.redundant_relationship.invalid',
          first_title:  @first,
          second_title: @second,
          relationship: @first
        )
      )
    end

    unless record.try(@first).try(@all_seconds)&.include?(record.try(@second))
      return
    end

    record.errors.add(
      :base,
      I18n.t(
        'validators.redundant_relationship.invalid',
        first_title:  @second,
        second_title: @first,
        relationship: @second
      )
    )
  end
  # rubocop:enable Metrics/MethodLength
end

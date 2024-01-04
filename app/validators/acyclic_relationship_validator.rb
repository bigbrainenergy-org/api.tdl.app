class AcyclicRelationshipValidator < RelationshipValidator
  # rubocop:disable Metrics/MethodLength
  def validate(record)
    return unless relationship_persisted?(record)
    # pre is already a post of post
    unless record.try(@first).try(@all_firsts).include?(record.try(@second))
      return
    end

    record.errors.add(
      :base,
      I18n.t(
        'validators.acyclic_relationship.invalid',
        first_title:  record.try(@first).title,
        second_title: record.try(@second).title
      )
    )
  end
  # rubocop:enable Metrics/MethodLength
end

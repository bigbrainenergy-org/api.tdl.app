class AcyclicRelationshipValidator < RelationshipValidator
  def validate(record)
    return unless relationship_persisted?
    return unless record.try(@first).try(@all_firsts).include?(record.try(@second))

    # pre is already a post of post
    record.errors.add(
      :base,
      I18n.t(
        'validators.rule.redundant_rule',
        task_i_title:  record.pre.title,
        task_ii_title: record.post.title
      )
    )
  end
end

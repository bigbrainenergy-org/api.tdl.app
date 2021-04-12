class RuleAcyclicValidator < ActiveModel::Validator
  # FIXME: interested to see how this could be written not to trip AbcSize
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  def validate(record)
    return if record.pre.blank? || record.post.blank?
    return unless record.pre.present? && record.post.present?
    return unless record.pre.persisted? && record.post.persisted?
    return unless record.pre.all_pres.include?(record.post)

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
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/AbcSize
end

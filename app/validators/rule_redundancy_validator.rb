class RuleRedundancyValidator < ActiveModel::Validator
  # FIXME: aside from cookie-cutter validations, there is one condition
  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def validate(record)
    # validation
    # A -> B -> C -> D
    # A -> D
    #
    return unless record.pre.present? && record.post.present?
    return unless record.pre.persisted? && record.post.persisted?
    # FIXME: any way to use OR `||` on multiple lines?
    # rubocop:disable Layout/LineLength
    return unless record.post.all_pres.include?(record.pre) || record.pre.all_posts.include?(record.post)
    # rubocop:enable Layout/LineLength

    record.errors.add(
      :base,
      I18n.t(
        'validators.rule.redundant_rule',
        task_i_title:  record.post.title,
        task_ii_title: record.pre.title
      )
    )
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end

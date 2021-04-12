class UsernameFormattingValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    return if value.blank?
    # NOTE: Regex is witchcraft
    return unless /\s/.match?(value)

    record.errors.add(
      field,
      message: I18n.t('validators.username_formatting.must_not_contain_spaces')
    )
  end
end

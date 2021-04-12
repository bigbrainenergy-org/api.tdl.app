class EmailFormattingValidator < ActiveModel::EachValidator
  # TODO: Split this into two validators: regex and lowercase, or turn them into
  #       validator params
  # rubocop:disable Metrics/MethodLength
  def validate_each(record, field, value)
    return if value.blank?

    if value != value.downcase
      record.errors.add(
        field,
        message: I18n.t('validators.email_formatting.must_be_lowercase')
      )
    end

    # NOTE: Regex is witchcraft
    return if URI::MailTo::EMAIL_REGEXP.match?(value)

    record.errors.add(
      field,
      message: I18n.t('validators.email_formatting.invalid_format')
    )
  end
  # rubocop:enable Metrics/MethodLength
end

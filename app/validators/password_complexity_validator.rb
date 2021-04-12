class PasswordComplexityValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    return if value.blank? || password_complexity(value) >= 3

    record.errors.add(
      field,
      message: I18n.t('validators.password_complexity.not_enough_complexity')
    )
  end

  def password_complexity(value)
    complexity = 0
    # Any Upper-case Letters
    complexity += 1 if /[A-Z]/.match?(value)
    # Any Lower-case letters
    complexity += 1 if /[a-z]/.match?(value)
    # Any digits
    complexity += 1 if /[0-9]/.match?(value)
    # Any Special Characters (non-alphanumeric nor whitespace)
    complexity += 1 if value.gsub(/[A-Za-z0-9\s+]/, '').length.positive?
    complexity
  end
end

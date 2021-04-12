class LocaleAvailabilityValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    return if value.blank? || I18n.available_locales.include?(value.to_sym)

    record.errors.add(
      field,
      message: I18n.t('validators.locale_availability.unavailable')
    )
  end
end

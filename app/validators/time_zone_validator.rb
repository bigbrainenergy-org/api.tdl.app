class TimeZoneValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    return if value.blank? || ActiveSupport::TimeZone[value].present?

    record.errors.add(field, message: I18n.t('validators.time_zone.invalid'))
  end
end

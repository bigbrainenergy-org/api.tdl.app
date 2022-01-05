class SameUserValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    return if value.blank?
    return if value.user == record.user

    record.errors.add(
      field,
      message: I18n.t(
        'validators.same_user.invalid',
        record_class: record.class.name.underscore.titleize
      )
    )
  end
end

class IconFormattingValidator < ActiveModel::EachValidator
  def validate_each(record, field, value)
    return if value.blank?
    # TODO: Support a predefined set of icons (e.g. all material icons and font
    #       awesome icons)
    return if value == 'local_offer'

    record.errors.add(
      field,
      message: I18n.t('validators.icon_formatting.invalid_icon')
    )
  end
end
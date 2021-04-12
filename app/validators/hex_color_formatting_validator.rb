class HexColorFormattingValidator < ActiveModel::EachValidator
  # rubocop:disable Metrics/MethodLength
  def validate_each(record, field, value)
    return if value.blank?

    # FIXME: create a Hex Color concern to store Hex Color logic.
    # while randomize_color only generates 6-character colors,
    # 3 or 6 are valid rgb
    if value[0] != '#'
      record.errors.add(
        field,
        message: I18n.t('validators.hex_color_formatting.must_be_prefixed_with_octothorpe')
      )
    end

    return if /\A#(\h{3}){1,2}\z/.match?(value)

    record.errors.add(
      field,
      message: I18n.t('validators.hex_color_formatting.invalid_format')
    )
  end
  # rubocop:enable Metrics/MethodLength
end

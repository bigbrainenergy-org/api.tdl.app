class ScheduleBlocksValidator < ActiveModel::EachValidator
  VALID_DAYS = %w[sun mon tue wed thu fri sat].freeze

  def validate_each(record, field, value)
    unless value.is_a?(Array)
      record.errors.add(field, message: 'must be an array')
      return
    end

    value.each_with_index do |block, index|
      validate_block(record, field, block, index)
    end
  end

  private

  def validate_block(record, field, block, index)
    unless block.is_a?(Hash)
      record.errors.add(field, message: "block at index #{index} must be an object")
      return
    end

    unless VALID_DAYS.include?(block['day_of_week'])
      record.errors.add(field, message: "block at index #{index} has invalid day_of_week (must be one of: #{VALID_DAYS.join(', ')})")
    end

    unless block['start'].is_a?(String) && block['start'].present?
      record.errors.add(field, message: "block at index #{index} must have a start time")
    end

    unless block['end'].is_a?(String) && block['end'].present?
      record.errors.add(field, message: "block at index #{index} must have an end time")
    end
  end
end

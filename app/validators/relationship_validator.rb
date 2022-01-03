class RelationshipValidator < ActiveModel::Validator
  def initialize(options)
    super

    @first = options[:first] || :first
    @second = options[:second] || :second
    @all_firsts = options[:all_firsts] || :all_firsts
    @all_seconds = options[:all_seconds] || :all_seconds
  end

  def validate(record)
    raise NotImplementedError
  end

  protected

  def relationship_persisted?
    record.try(@first)&.persisted? && record.try(@second)&.persisted?
  end
end

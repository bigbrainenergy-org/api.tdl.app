require 'rails_helper'

# FIXME: Why are we using doubles?
# rubocop:disable RSpec/VerifiedDoubles
# FIXME: Why are we using doubles??
# rubocop:disable RSpec/LeakyConstantDeclaration
# FIXME: WHY ARE WE USING DOUBLES?!?!
# rubocop:disable Lint/ConstantDefinitionInBlock
RSpec.describe SameUserValidator do
  subject(:validator) { described_class.new(attributes: [:validated_field]) }

  class DummyModel
    include ActiveModel::Validations
    attr_accessor :user, :validated_field

    validates :validated_field, same_user: true
  end
  let(:user) { User.new }
  let(:other_user) { User.new }
  let(:record) { DummyModel.new }

  context 'when record value is blank' do
    it 'does not add any error and should exit the validator' do
      record.validated_field = nil
      validator.validate_each(record, :validated_field, record.validated_field)
      expect(record.errors[:validated_field]).to be_empty
    end
  end

  context 'when the field value user is the same as the record user' do
    it 'does not add any error and should exit the validator' do
      record.user = user
      record.validated_field = double(user: user)
      validator.validate_each(record, :validated_field, record.validated_field)
      expect(record.errors[:validated_field]).to be_empty
    end
  end

  # rubocop:disable RSpec/ExampleLength
  context 'when the field value user DIFFERS from the record user' do
    it 'adds an error' do
      record.user = user
      record.validated_field = double(user: other_user)
      validator.validate_each(record, :validated_field, record.validated_field)
      expect(record.errors[:validated_field]).to include(
        I18n.t(
          'validators.same_user.invalid',
          record_class: record.class.name.underscore.titleize
        )
      )
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
# rubocop:enable RSpec/VerifiedDoubles
# rubocop:enable RSpec/LeakyConstantDeclaration
# rubocop:enable Lint/ConstantDefinitionInBlock

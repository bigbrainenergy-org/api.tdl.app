require 'rails_helper'

RSpec.describe InboxItem do
  subject(:record) { build :inbox_item }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    # TODO: Add tests or remove placeholder
  end

  describe 'validations' do
    # TODO: Add tests or remove placeholder
  end

  describe 'callbacks' do
    # TODO: Add tests or remove placeholder
  end

  describe 'scopes' do
    # TODO: Add tests or remove placeholder
  end

  describe 'class method' do
    # TODO: Add tests or remove placeholder
  end

  describe 'instance method' do
    # TODO: Add tests or remove placeholder
  end
end

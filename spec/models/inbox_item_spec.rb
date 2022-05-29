require 'rails_helper'

RSpec.describe InboxItem do
  subject(:record) { build :inbox_item }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end
end

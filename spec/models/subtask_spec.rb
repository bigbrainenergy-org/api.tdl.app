require 'rails_helper'

RSpec.describe Subtask do
  subject(:record) { build(:subtask) }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:task) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:order) }
  end
end

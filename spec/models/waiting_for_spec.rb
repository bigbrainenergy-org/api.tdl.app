require 'rails_helper'

RSpec.describe WaitingFor do
  subject(:record) { build :waiting_for }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:order) }
    it { should validate_presence_of(:delegated_to) }
  end
end

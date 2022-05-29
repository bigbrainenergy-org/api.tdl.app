require 'rails_helper'

RSpec.describe NextActionHardRequisite do
  subject(:record) { build :next_action_hard_requisite }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:pre) }
    it { should belong_to(:post) }
  end
end

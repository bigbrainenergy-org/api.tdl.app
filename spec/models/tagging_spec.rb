require 'rails_helper'

RSpec.describe Tagging do
  subject(:record) { build :tagging }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:tag) }
    it { should belong_to(:task) }
  end
end

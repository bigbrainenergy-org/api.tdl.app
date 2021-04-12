require 'rails_helper'

RSpec.describe List do
  subject(:record) { build :list }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id) }

    it { should validate_presence_of(:order) }
  end
end

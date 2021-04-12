require 'rails_helper'

RSpec.describe Task do
  subject(:record) { build :task }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:list) }
    it { should belong_to(:user) }

    it { should have_many(:pre_rules).dependent(:destroy) }
    it { should have_many(:post_rules).dependent(:destroy) }

    it { should have_many(:tags).through(:taggings).order(order: :asc, title: :asc) }
    it { should have_many(:prereqs).through(:pre_rules) }
    it { should have_many(:postreqs).through(:post_rules) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id) }
  end
end

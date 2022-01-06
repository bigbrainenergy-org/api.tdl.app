require 'rails_helper'

RSpec.describe Project do
  subject(:record) { build :project }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }

    it { should have_many(:superproject_relationships).dependent(:destroy) }
    it { should have_many(:subproject_relationships).dependent(:destroy) }
    it { should have_many(:superprojects).through(:superproject_relationships) }
    it { should have_many(:subprojects).through(:subproject_relationships) }

    it { should have_many(:hard_pre_relationships).dependent(:destroy) }
    it { should have_many(:hard_post_relationships).dependent(:destroy) }
    it { should have_many(:hard_prereqs).through(:hard_pre_relationships) }
    it { should have_many(:hard_postreqs).through(:hard_post_relationships) }

    it { should have_many(:next_actions).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id) }

    it { should validate_presence_of(:order) }
    it { should validate_presence_of(:status) }
  end
end

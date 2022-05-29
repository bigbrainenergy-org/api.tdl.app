require 'rails_helper'

RSpec.describe NextAction do
  subject(:record) { build :next_action }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:context).optional }
    it { should belong_to(:project).optional }

    it { should have_many(:hard_pre_relationships).dependent(:destroy) }
    it { should have_many(:hard_post_relationships).dependent(:destroy) }
    it { should have_many(:hard_prereqs).through(:hard_pre_relationships) }
    it { should have_many(:hard_postreqs).through(:hard_post_relationships) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:order) }

    it { should validate_presence_of(:mental_energy_required) }
    it { should validate_numericality_of(:mental_energy_required).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }

    it { should validate_presence_of(:physical_energy_required) }
    it { should validate_numericality_of(:physical_energy_required).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
  end
end

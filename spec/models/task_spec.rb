require 'rails_helper'

RSpec.describe Task do
  subject(:record) { build(:task) }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:list) }
    it { should belong_to(:status).optional }
    it { should have_one(:user).through(:list) }
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

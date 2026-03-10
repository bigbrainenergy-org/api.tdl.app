require 'rails_helper'

RSpec.describe TaskDependency do
  subject(:record) { build(:task_dependency) }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:pre) }
    it { should belong_to(:post) }
  end

  describe 'validations' do
    it { should allow_value(nil).for(:degree) }
    it { should allow_value(1).for(:degree) }
    it { should allow_value(2).for(:degree) }
    it { should allow_value(3).for(:degree) }
    it { should_not allow_value(0).for(:degree) }
    it { should_not allow_value(4).for(:degree) }
  end
end

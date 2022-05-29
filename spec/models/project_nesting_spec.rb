require 'rails_helper'

RSpec.describe ProjectNesting do
  subject(:record) { build :project_nesting }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:superproject) }
    it { should belong_to(:subproject) }
  end
end

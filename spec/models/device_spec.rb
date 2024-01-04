require 'rails_helper'

RSpec.describe Device do
  subject(:record) { build(:device) }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_agent) }
    it { should validate_presence_of(:last_seen_at) }
    it { should validate_presence_of(:push_endpoint) }
    it { should validate_presence_of(:push_p256dh) }
    it { should validate_presence_of(:push_auth) }
  end
end

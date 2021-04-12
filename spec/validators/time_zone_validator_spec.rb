require 'rails_helper'

RSpec.describe TimeZoneValidator do
  subject(:validator) { validator_model_mock }

  context 'when valid time zone' do
    let(:value) { 'Pacific Time (US & Canada)' }

    it { should be_valid }
  end

  context 'when empty string' do
    let(:value) { '' }

    it { should be_valid }
  end

  context 'when nil' do
    let(:value) { nil }

    it { should be_valid }
  end

  context 'when invalid time zone' do
    let(:value) { 'nope!' }

    it { should be_invalid }
    it { should have_validation_error(I18n.t('validators.time_zone.invalid')) }
  end
end

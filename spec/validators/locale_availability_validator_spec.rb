require 'rails_helper'

RSpec.describe LocaleAvailabilityValidator do
  subject(:validator) { validator_model_mock }

  context 'when valid locale' do
    [
      'en', # English
      'ja'  # Japanese
    ].each do |valid_locale|
      context valid_locale.to_s do
        let(:value) { valid_locale }

        it { should be_valid }
      end
    end
  end

  context 'when empty string' do
    let(:value) { '' }

    it { should be_valid }
  end

  context 'when nil' do
    let(:value) { nil }

    it { should be_valid }
  end

  context 'when unavailable locale' do
    let(:value) { 'ru' }

    it { should be_invalid }
    it { should have_validation_error(I18n.t('validators.locale_availability.unavailable')) }
  end

  context 'when invalid locale' do
    let(:value) { 'nope!' }

    it { should be_invalid }
    it { should have_validation_error(I18n.t('validators.locale_availability.unavailable')) }
  end
end

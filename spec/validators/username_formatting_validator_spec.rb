require 'rails_helper'

RSpec.describe UsernameFormattingValidator do
  subject(:validator) { validator_model_mock }

  context 'when valid username' do
    [
      'john-smith',
      '1337Hax0r',
      'haha_economy_goes_brrr',
      '💩💩💩',
      '水'
    ].each do |valid_email|
      context valid_email.to_s do
        let(:value) { valid_email }

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

  context 'when username contains spaces' do
    let(:value) { 'John Smith' }

    it { should be_invalid }
    it { should have_validation_error(I18n.t('validators.username_formatting.must_not_contain_spaces')) }
  end
end

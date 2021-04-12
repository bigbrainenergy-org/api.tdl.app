require 'rails_helper'

RSpec.describe PasswordComplexityValidator do
  subject(:validator) { validator_model_mock }

  context 'when password has enough complexity' do
    [
      'AmazingPassword!',
      'Fantastic4',
      '$up3rdup3r',
      '2$h0Rt'
    ].each do |valid_password|
      context valid_password.to_s do
        let(:value) { valid_password }

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

  context 'when password is not complex enough' do
    [
      'password',
      'AlphaNumericYo',
      '12345!@#$%',
      'password12345',
      'PASSWORD!@#$%'
    ].each do |invalid_password|
      context invalid_password.to_s do
        let(:value) { invalid_password }

        it { should be_invalid }
        it { should have_validation_error(I18n.t('validators.password_complexity.not_enough_complexity')) }
      end
    end
  end
end

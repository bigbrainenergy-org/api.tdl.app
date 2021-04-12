require 'rails_helper'

RSpec.describe EmailFormattingValidator do
  subject(:validator) { validator_model_mock }

  context 'when valid email' do
    [
      'john-smith@example.com',
      'smith.john+ccsk@example.com'
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

  context 'when email has uppercase letters' do
    let(:value) { 'Smith.John+ccsk@example.com' }

    it { should be_invalid }
    it { should have_validation_error(I18n.t('validators.email_formatting.must_be_lowercase')) }
    it { should_not have_validation_error(I18n.t('validators.email_formatting.invalid_format')) }
  end

  # rubocop:disable Layout/LineLength
  context 'when email has uppercase letters and fails regex' do
    [
      'Jon.Snow@night.watch.com    Bran.Stark@winterfell.com    Harry.Potter@winterfell.com',
      'Jon.Snow@night.watch.com,Bran.Stark@winterfell.com,Harry.Potter@winterfell.com',
      'Jon.Snow@night.watch.com, Bran.Stark@winterfell.com',
      "Jon.Snow@night.watch.com\tBran.Stark@winterfell.com\tHarry.Potter@winterfell.com"
    ].each do |uppercase_email|
      context uppercase_email.to_s do
        let(:value) { uppercase_email }

        it { should be_invalid }
        it { should have_validation_error(I18n.t('validators.email_formatting.must_be_lowercase')) }
        it { should have_validation_error(I18n.t('validators.email_formatting.invalid_format')) }
      end
    end
  end

  context 'when email fails regex validation' do
    [
      'john-smith',
      'bad.format+ccsk@',
      'jon.snow@night.watch.com    bran.stark@winterfell.com    harry.potter@winterfell.com',
      'jon.snow@night.watch.com,bran.stark@winterfell.com,harry.potter@winterfell.com',
      'jon.snow@night.watch.com, bran.stark@winterfell.com',
      "jon.snow@night.watch.com\tbran.stark@winterfell.com\tharry.potter@winterfell.com"
    ].each do |invalid_email|
      context invalid_email.to_s do
        let(:value) { invalid_email }

        it { should be_invalid }
        it { should_not have_validation_error(I18n.t('validators.email_formatting.must_be_lowercase')) }
        it { should have_validation_error(I18n.t('validators.email_formatting.invalid_format')) }
      end
    end
  end
  # rubocop:enable Layout/LineLength
end

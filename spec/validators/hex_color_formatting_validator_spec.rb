require 'rails_helper'

RSpec.describe HexColorFormattingValidator do
  subject(:validator) { validator_model_mock }

  context 'when valid hex color' do
    [
      '#aaa',
      '#aaA',
      '#0aA',
      '#000',
      '#aaaaaa',
      '#aaaAaa',
      '#0aA0aA',
      '#000000',
      '#012345',
      '#6789ab',
      '#cdefAB',
      '#CDEF01'
    ].each do |valid_color|
      context valid_color.to_s do
        let(:value) { valid_color }

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

  context 'when color has 3 or 6 hexadecimal digits but lacks octothorpe' do
    %w[
      aaa
      aaA
      0aA
      000
      aaaaaa
      aaaAaa
      0aA0aA
      000000
      012345
      6789ab
      cdefAB
      CDEF01
    ].each do |prefixed_hex_color|
      context prefixed_hex_color.to_s do
        let(:value) { prefixed_hex_color }

        it { should be_invalid }
        it { should have_validation_error(I18n.t('validators.hex_color_formatting.must_be_prefixed_with_octothorpe')) }
        it { should have_validation_error(I18n.t('validators.hex_color_formatting.invalid_format')) }
      end
    end
  end

  context 'when input fails regex match entirely' do
    [
      'red',
      '3.14',
      'According to all known laws of aviation, there is no way that a bee ' \
      'should be able to fly. Its wings are too small to get its fat little ' \
      'body off the ground. The bee, of course, flies anyways.'
    ].each do |invalid_color|
      context invalid_color.to_s do
        let(:value) { invalid_color }

        it { should be_invalid }
        it { should have_validation_error(I18n.t('validators.hex_color_formatting.must_be_prefixed_with_octothorpe')) }
        it { should have_validation_error(I18n.t('validators.hex_color_formatting.invalid_format')) }
      end
    end
  end

  context 'when input is invalid but has octothorpe' do
    [
      '#red',
      '#3.14',
      '#DEEZNUTS', # I will have my memes, or I will have death
      '# FFF',
      '# ff00ff',
      '#12345',
      '#',
      '#According to all known laws of aviation, there is no way that a bee ' \
      'should be able to fly. Its wings are too small to get its fat little ' \
      'body off the ground. The bee, of course, flies anyways.'
    ].each do |invalid_color|
      context invalid_color.to_s do
        let(:value) { invalid_color }

        it { should be_invalid }
        it { should_not have_validation_error(I18n.t('validators.hex_color_formatting.must_be_prefixed_with_octothorpe')) }
        it { should have_validation_error(I18n.t('validators.hex_color_formatting.invalid_format')) }
      end
    end
  end
end

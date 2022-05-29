require 'rails_helper'

RSpec.describe Context do
  subject(:record) { build :context }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }

    it { should have_many(:next_actions).dependent(:restrict_with_exception) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title).case_insensitive.scoped_to(:user_id) }

    pending { should validate_presence_of(:color) }
    it { should validate_hex_color_formatting_of(:color) }

    pending { should validate_presence_of(:icon) }
    it { should validate_presence_of(:order) }
  end

  describe 'instance method' do
    describe 'randomize_color!' do
      let(:regex_hex_color) { /\A#(\h{3}){1,2}\z/ }

      context 'when color value is empty string' do
        subject(:color) do
          context = build :context, color: ''
          context.randomize_color!
          context.color
        end

        it { should match(regex_hex_color) }
      end

      context 'when color value is nil' do
        subject(:color) do
          context = build :context, color: nil
          context.randomize_color!
          context.color
        end

        it { should match(regex_hex_color) }
      end

      context 'when color value is already set' do
        subject(:color) do
          context = build :context, color: a_random_color
          context.randomize_color!
          context.color
        end

        let(:a_random_color) { Faker::Color.hex_color }

        it { should_not eq(a_random_color) }
        it { should match(regex_hex_color) }
      end
    end
  end
end

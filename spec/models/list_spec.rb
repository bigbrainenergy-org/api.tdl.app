require 'rails_helper'

RSpec.describe List do
  subject(:record) { build(:list) }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:restrict_with_exception) }
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
          list = build(:list, color: '')
          list.randomize_color!
          list.color
        end

        it { should match(regex_hex_color) }
      end

      context 'when color value is nil' do
        subject(:color) do
          list = build(:list, color: nil)
          list.randomize_color!
          list.color
        end

        it { should match(regex_hex_color) }
      end

      context 'when color value is already set' do
        subject(:color) do
          list = build(:list, color: a_random_color)
          list.randomize_color!
          list.color
        end

        let(:a_random_color) { Faker::Color.hex_color }

        it { should_not eq(a_random_color) }
        it { should match(regex_hex_color) }
      end
    end
  end

  describe 'callbacks' do
    # TODO: Add tests or remove placeholder
  end

  describe 'scopes' do
    # TODO: Add tests or remove placeholder
  end

  describe 'class method' do
    # TODO: Add tests or remove placeholder
  end
end

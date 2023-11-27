require 'rails_helper'

RSpec.describe User do
  subject(:record) { build :user }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'associations' do
    it { should have_many(:devices).dependent(:destroy) }
    it { should have_many(:user_sessions).dependent(:destroy) }

    it { should have_many(:lists).dependent(:destroy) }
    it { should have_many(:tasks).through(:lists) }
  end

  describe 'validations' do
    it { should validate_presence_of(:given_name) }
    it { should validate_presence_of(:family_name) }

    it { should validate_presence_of(:time_zone) }
    it { should validate_time_zone_of(:time_zone) }

    it { should validate_presence_of(:locale) }
    it { should validate_locale_availability_of(:locale) }

    it { should validate_presence_of(:username) }
    it { should validate_length_of(:username).is_at_most(69) } # nice
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_username_formatting_of(:username) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_email_formatting_of(:email) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(14).is_at_most(128) }

    it { should validate_presence_of(:terms_and_conditions) }
  end

  describe 'instance method' do
    describe 'bypass_password?' do
      context 'when bypass_password is true' do
        subject(:bypass_password?) do
          user = build :user
          user.bypass_password = true
          user.bypass_password?
        end

        it { should be_truthy }
      end

      context 'when bypass_password is an arbitrary string' do
        subject(:bypass_password?) do
          user = build :user
          user.bypass_password = Faker::String.random
          user.bypass_password?
        end

        it { should be_truthy }
      end

      context 'when bypass_password is false' do
        subject(:bypass_password?) do
          user = build :user
          user.bypass_password = false
          user.bypass_password?
        end

        it { should be_falsey }
      end

      context 'when bypass_password is nil' do
        subject(:bypass_password?) do
          user = build :user
          user.bypass_password = nil
          user.bypass_password?
        end

        it { should be_falsey }
      end
    end
  end
end

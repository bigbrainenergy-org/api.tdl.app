require 'rails_helper'

RSpec.describe AccessRequest do
  subject(:record) { build(:access_request) }

  it 'has valid factory' do
    expect(record).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_email_formatting_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:reason_for_interest) }
    it { should validate_presence_of(:version) }

    # FIXME: Not a fan of how enums work in Rails...

    context 'with good version' do
      %w[alpha beta release].each do |version|
        context "when \"#{version}\"" do
          subject(:record) { build(:access_request, version: version) }

          it { should be_valid }
        end
      end
    end

    context 'with no version' do
      subject(:record) { build(:access_request, version: nil) }

      it { should be_invalid }
    end

    context 'with bad version' do
      %w[fake rELeAsE Beta].each do |version|
        context "when \"#{version}\"" do
          subject(:record) { build(:access_request, version: version) }

          it 'raises an ArgumentError' do
            expect { record }.to raise_error ArgumentError
          end
        end
      end
    end
  end
end

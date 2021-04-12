FactoryBot.define do
  factory :access_request do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    reason_for_interest { Faker::Lorem.paragraphs }
    version { %w[alpha beta release].sample }
  end
end

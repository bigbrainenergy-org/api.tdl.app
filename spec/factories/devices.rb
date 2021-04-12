FactoryBot.define do
  factory :device do
    user
    name { nil }
    push_endpoint { Faker::Internet.url }
    push_p256dh { Faker::String.random }
    push_auth { Faker::String.random }
    user_agent { Faker::Internet.user_agent }
    last_seen_at { Faker::Time.backward }
  end
end

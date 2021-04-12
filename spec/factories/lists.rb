FactoryBot.define do
  factory :list do
    user
    title { "a#{Faker::String.random}" }
  end
end

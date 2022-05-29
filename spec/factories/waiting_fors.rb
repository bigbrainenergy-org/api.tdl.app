FactoryBot.define do
  factory :waiting_for do
    user

    title { "a#{Faker::String.random}" }
    notes { [Faker::Lorem.paragraphs.join, nil].sample }
    delegated_to { Faker::Name.name }
    completed { [true, false].sample }
  end
end

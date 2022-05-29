FactoryBot.define do
  factory :next_action do
    user

    title { "a#{Faker::String.random}" }
    notes { [Faker::Lorem.paragraphs, nil].sample }
    completed { [true, false].sample }
  end
end

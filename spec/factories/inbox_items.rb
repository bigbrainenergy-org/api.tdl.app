FactoryBot.define do
  factory :inbox_item do
    user

    title { "a#{Faker::String.random}" }
    notes { [Faker::Lorem.paragraphs, nil].sample }
  end
end

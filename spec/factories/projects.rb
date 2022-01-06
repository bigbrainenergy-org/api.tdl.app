FactoryBot.define do
  factory :project do
    user

    title { "a#{Faker::String.random}" }
    notes { [Faker::Lorem.paragraphs.join, nil].sample }
    status { ['active', 'paused', 'completed'].sample }
  end
end

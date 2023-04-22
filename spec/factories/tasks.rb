FactoryBot.define do
  factory :task do
    list
    status

    title { "a#{Faker::String.random}" }
    notes { [Faker::Lorem.paragraphs, nil].sample }
    completed { [true, false].sample }
    delegated { [true, false].sample }
    
  end
end

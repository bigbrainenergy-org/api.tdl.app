FactoryBot.define do
  factory :subtask do
    next_action

    title { "a#{Faker::String.random}" }
    completed { [true, false].sample }
  end
end

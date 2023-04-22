FactoryBot.define do
  factory :subtask do
    task
    title { "a#{Faker::String.random}" }
    completed { [true, false].sample }
    order { 1 }
  end
end

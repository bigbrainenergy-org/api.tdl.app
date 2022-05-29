FactoryBot.define do
  factory :context do
    user

    title { "a#{Faker::String.random}" }
    icon { ['local_offer'].sample } # Problem, officer?
    color { Faker::Color.hex_color }
  end
end

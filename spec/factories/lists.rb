FactoryBot.define do
  factory :list do
    user

    title { "a#{Faker::String.random}" }
    color { Faker::Color.hex_color }
    icon { ['local_offer'].sample }
    order { 1 }
  end
end

FactoryBot.define do
  factory :tag do
    user
    title { "a#{Faker::String.random}" }
    color { Faker::Color.hex_color }
  end
end

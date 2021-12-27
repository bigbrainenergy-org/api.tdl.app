FactoryBot.define do
  factory :inbox_item do
    user

    title { "a#{Faker::String.random}" }
    notes { [Faker::Lorem.paragraphs, nil].sample }
    review_by do
      [Faker::Time.between(from: 1.year.ago, to: 1.year.from_now), nil].sample
    end
  end
end

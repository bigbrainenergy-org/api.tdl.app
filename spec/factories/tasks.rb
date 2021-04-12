FactoryBot.define do
  factory :task do
    user
    list do
      association :list, user: user
    end

    title { "a#{Faker::String.random}" }
    completed_at { [Faker::Time.backward, nil].sample }
    notes { [Faker::Lorem.paragraphs, nil].sample }

    review_at do
      [Faker::Time.between(from: 1.year.ago, to: 1.year.from_now), nil].sample
    end

    deadline_at do
      [Faker::Time.between(from: 1.year.ago, to: 1.year.from_now), nil].sample
    end

    prioritize_at do
      [Faker::Time.between(from: 1.year.ago, to: 1.year.from_now), nil].sample
    end

    remind_me_at do
      [Faker::Time.between(from: 1.year.ago, to: 1.year.from_now), nil].sample
    end
  end
end

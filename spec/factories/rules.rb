FactoryBot.define do
  factory :rule do
    association :pre,  factory: :task
    association :post, factory: :task
  end
end

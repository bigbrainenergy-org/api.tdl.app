FactoryBot.define do
  factory :next_action_hard_requisite do
    association :pre,  factory: :task
    association :post, factory: :task
  end
end

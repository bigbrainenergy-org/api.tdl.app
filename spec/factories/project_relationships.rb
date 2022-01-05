FactoryBot.define do
  factory :project_nesting do
    association :superproject, factory: :task
    association :subproject,   factory: :task
  end

  factory :project_hard_requisite do
    association :pre,  factory: :task
    association :post, factory: :task
  end
end

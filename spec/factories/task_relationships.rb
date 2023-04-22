FactoryBot.define do
  factory :task_hard_requisite do
    # FIXME: This code is shit, do not use it as an example.
    transient do
      user { build :user }
    end

    pre { build :task, user: user }
    post { build :task, user: user }
  end
end

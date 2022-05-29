FactoryBot.define do
  factory :next_action_hard_requisite do
    # FIXME: This code is shit, do not use it as an example.
    transient do
      user { build :user }
    end

    pre { build :next_action, user: user }
    post { build :next_action, user: user }
  end
end

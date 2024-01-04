FactoryBot.define do
  factory :task_hard_requisite do
    # FIXME: This code is shit, do not use it as an example.
    transient do
      # Create a common user so we don't trip the "different users" validation
      # rubocop:disable FactoryBot/FactoryAssociationWithStrategy
      user { build(:user) }
      # rubocop:enable FactoryBot/FactoryAssociationWithStrategy
    end

    pre { association :task, user: user }
    post { association :task, user: user }
  end
end

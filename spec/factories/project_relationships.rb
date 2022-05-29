FactoryBot.define do
  factory :project_nesting do
    # FIXME: This code is shit, do not use it as an example.
    transient do
      user { build :user }
    end

    superproject { build :project, user: user }
    subproject { build :project, user: user }
  end

  factory :project_hard_requisite do
    # FIXME: This code is shit, do not use it as an example.
    transient do
      user { build :user }
    end

    pre { build :project, user: user }
    post { build :project, user: user }
  end
end

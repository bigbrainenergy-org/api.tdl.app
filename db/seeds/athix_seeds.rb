athix = User.create!(
  username:             'athix',
  given_name:           'Josh',
  family_name:          'Buker',
  email:                'athix@tdl.app',
  password:             'correcthorsebatterystaple',
  time_zone:            'Pacific Time (US & Canada)',
  terms_and_conditions: Time.current
)

athix.prepopulate_contexts!

def random_notes
  return nil if [true, false].sample

  [
    Faker::Lorem.paragraphs.join,
    "#{Faker::Lorem.paragraphs.join}\n\n#{Faker::Markdown.ordered_list}"
  ].sample
end

def random_inbox_item_title
  [
    "Plan a vacation to #{
      [Faker::Space.star, Faker::Address.country].sample
    }",
    "#{Faker::Company.catch_phrase} to #{Faker::Company.bs} for maximum #{Faker::Company.buzzword} value",
    "Call #{Faker::Name.name} about the #{Faker::Space.launch_vehicle} mission",
    "Check out the #{Faker::Science.tool}"
  ].sample
end

def random_inbox_item_notes
  random_notes
end

# TODO: Differentiate from inbox items
def random_next_action_title
  random_inbox_item_title
end

def random_next_action_notes
  random_notes
end

def random_waiting_for_title
  random_inbox_item_title
end

def random_waiting_for_notes
  random_notes
end

# TODO: Add more
def random_project_title
  "Plan a vacation to #{
    [Faker::Space.star, Faker::Address.country].sample
  }"
end

def random_project_notes
  random_notes
end

def populate_next_actions(project)
  next_actions_count = [0, rand(1..3), rand(4..7), 69].sample

  next_actions_count.times do |n|
    NextAction.create!(
      user: project.user,
      project: project,
      title: random_next_action_title,
      notes: random_next_action_notes
    )
  end
end

# Recursive generation goes brrr
def populate_subprojects(superproject, nesting = 0)
  return if nesting >= 3
  # There must be at least one zero, otherwise this will run indefinitely
  subproject_count = [0, 0, 0, 1, 2, 3].sample

  subproject_count.times do |n|
    begin
    subproject = Project.create!(
      user: superproject.user,
      title: "#{superproject.title} - #{n}",
      notes: random_project_notes
    )
    rescue StandardError => e
      byebug
    end

    ProjectNesting.create!(
      superproject: superproject,
      subproject: subproject
    )

    populate_next_actions(subproject)
    populate_subprojects(subproject, nesting + 1)
  end
end

#################
## Inbox Items ##
#################

25.times do |n|
  InboxItem.create!(
    user: athix,
    title: "#{random_inbox_item_title} - #{n}",
    notes: random_inbox_item_notes
  )
end

##################
## Next Actions ##
##################

20.times do |n|
  NextAction.create!(
    user: athix,
    title: "#{random_next_action_title} - #{n}",
    notes: random_next_action_notes
  )
end

#################
## Waiting For ##
#################

15.times do |n|
  WaitingFor.create!(
    user: athix,
    title: "#{random_waiting_for_title} - #{n}",
    notes: random_waiting_for_notes
  )
end

##############
## Projects ##
##############

10.times do |n|
  superproject = Project.create!(
    user: athix,
    title: "#{random_project_title} - #{n}",
    notes: random_project_notes
  )
  populate_next_actions(superproject)
  populate_subprojects(superproject)
end

neo = User.create!(
  username:             'neo',
  given_name:           'Thomas',
  family_name:          'Anderson',
  email:                'neo@tdl.app',
  password:             'correcthorsebatterystaple',
  time_zone:            'Pacific Time (US & Canada)',
  terms_and_conditions: Time.current
)

inbox_list = List.create!(title: 'Inbox', color: '#bdbdbd', user: neo)
next_action_list = List.create!(title: 'Next Actions', color: '#72b2ed', user: neo)
waiting_for_list = List.create!(title: 'Waiting Fors', color: '#bdbdbd', user: neo)
project_list = List.create!(title: 'Projects', color: '#8e62bd', user: neo)

neo.update!(default_list: inbox_list)

def random_notes
  return nil if [true, false].sample

  [
    Faker::Lorem.paragraphs.join,
    "#{Faker::Lorem.paragraphs.join}\n\n#{Faker::Markdown.ordered_list}"
  ].sample
end

def random_title
  [
    "Plan a vacation to #{
      [Faker::Space.star, Faker::Address.country].sample
    }",
    "#{Faker::Company.catch_phrase} to #{Faker::Company.bs} for maximum " \
    "#{Faker::Company.buzzword} value",
    "Call #{Faker::Name.name} about the #{Faker::Space.launch_vehicle} mission",
    "Check out the #{Faker::Science.tool}"
  ].sample
end

#################
## Inbox Items ##
#################

25.times do |n|
  Task.create!(
    user:  neo,
    list:  inbox_list,
    title: "#{random_title} - #{n}",
    notes: random_notes
  )
end

##################
## Next Actions ##
##################

20.times do |n|
  Task.create!(
    user:  neo,
    list:  next_action_list,
    title: "#{random_title} - #{n}",
    notes: random_notes
  )
end

#################
## Waiting For ##
#################

15.times do |n|
  Task.create!(
    user:         neo,
    list:         waiting_for_list,
    title:        "#{random_title} - #{n}",
    notes:        random_notes
    # delegated_to: Faker::Name.name
  )
end

##############
## Projects ##
##############

10.times do |n|
  Task.create!(
    user:  neo,
    list:  project_list,
    title: "#{random_title} - #{n}",
    notes: random_notes
  )
end

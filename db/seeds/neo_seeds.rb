TASK_COMPLETION_CHANCE = 0.2
MINIMUM_LAYER_RATIO = 0.0
MAXIMUM_LAYER_RATIO = 1.2
MAXIMUM_TOTAL_LAYERS = 5
MINIMUM_PRES = 1
MAXIMUM_PRES = 5

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
next_action_list = List.create!(
  title: 'Next Actions',
  color: '#72b2ed',
  user:  neo
)
waiting_for_list = List.create!(
  title: 'Waiting Fors',
  color: '#bdbdbd',
  user:  neo
)
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

def create_task(user:, list:, title_key:, completed:)
  Task.create!(
    user:  user,
    list:  list,
    title: "#{random_title} - #{title_key}",
    notes: random_notes,
    completed: completed
  )
end

def random_completed_chance
  rand < TASK_COMPLETION_CHANCE
end

def calculate_next_layer_count(total_layers:, tasks_count:)
  random_count = (tasks_count * rand(MINIMUM_LAYER_RATIO..MAXIMUM_LAYER_RATIO)).ceil
  falloff = 1-(((total_layers-1)/(MAXIMUM_TOTAL_LAYERS-1).to_f) ** 2)
  (random_count * falloff).floor
end

def generate_task_tree(user:, list:, layer_zero_count:)
  puts "Generating tree for #{list.title} with a layer zero of #{layer_zero_count} incomplete tasks."
  current_layer = generate_layer_zero(user: user, list: list, count: layer_zero_count)
  total_layers = 1
  loop do
    next_layer_count = calculate_next_layer_count(
      total_layers: total_layers,
      tasks_count: current_layer.count
    )
    break if next_layer_count <= 0
    total_layers += 1
    puts "Generating layer of size: #{next_layer_count}"
    next_layer = generate_layer(user: user, list: list, count: next_layer_count)
    entangle_layers(tasks: current_layer, posts: next_layer)
    current_layer = next_layer
  end
  puts "Tree generation completed for #{list.title}!"
end

def generate_layer_zero(user:, list:, count:)
  layer = []
  # Ensure we have exactly the desired layer zero count
  count.times do |n|
    layer.push(create_task(user: user, list: list, title_key: n, completed: false))
  end

  # Create some completed tasks in layer zero to feed off of
  (TASK_COMPLETION_CHANCE*count).ceil.times do |n|
    layer.push(create_task(user: user, list: list, title_key: n, completed: true))
  end

  layer
end

def generate_layer(user:, list:, count:)
  layer = []
  count.times do |n|
    layer.push(create_task(user: user, list: list, title_key: n, completed: random_completed_chance))
  end
  layer
end

def entangle_layers(tasks:, posts:)
  posts.each do |post|
    pres_count = rand(MINIMUM_PRES..MAXIMUM_PRES).ceil
    tasks.shuffle.first(pres_count).each do |task|
      TaskHardRequisite.create!(
        pre: task,
        post: post
      )
      post.update!(completed: true) if task.completed?
    end
  end
end

####################
## Generate Tasks ##
####################

generate_task_tree(user: neo, list: inbox_list,       layer_zero_count: 8)
generate_task_tree(user: neo, list: next_action_list, layer_zero_count: 165)
generate_task_tree(user: neo, list: waiting_for_list, layer_zero_count: 5)
generate_task_tree(user: neo, list: project_list,     layer_zero_count: 127)

# rubocop:disable Metrics, Layout
generic_user = User.create!(
  username:             'user',
  given_name:           'John',
  family_name:          'Smith',
  email:                'username@domain',
  password:             'correcthorsebatterystaple',
  terms_and_conditions: Time.current
)

generic_user_list = List.create!(title: 'default list', user: generic_user)
generic_user.update!(default_list: generic_user_list)

tasks_count = 10_000
layers_count = 30
layer_zero_tasks = (tasks_count.to_f * 0.003).to_i
probability_to_add_post = 0.86
probability_to_add_post_that_exists = 0.35

layers = Array.new(layers_count) { [] }
current_task_id = 1
# get layer zero set up
layer_zero_tasks.times do |_n|
  puts "creating new task with title Task #{current_task_id}"
  tmp_task = Task.create!(
    title: "Task #{current_task_id}",
    list:  generic_user_list
  )
  tmp_task.save!
  layers[0].push(tmp_task)
  current_task_id += 1
end
current_layer = 0
loop do
  ramped_probability_to_add_post = probability_to_add_post**(current_layer + 1)
  layers[current_layer].each do |task|
    loop do
      break if rand > ramped_probability_to_add_post

      if rand <= probability_to_add_post_that_exists
        puts "using an existing task from the next layer to add postreq to #{task.title} - current layer: #{current_layer}"
        next_layer_tasks = layers[current_layer + 1]
        if next_layer_tasks.present?
          filtered_next_layer_tasks = next_layer_tasks.reject do |obj|
            task.hard_postreqs.include?(obj)
          end
          next_len = filtered_next_layer_tasks.length
          if next_len.positive?
            random_next_layer_task_index = rand(0..next_len - 1)
            rule = TaskHardRequisite.new(
              pre:  task,
              post: filtered_next_layer_tasks[random_next_layer_task_index]
            )
            rule.save!(validate: false)
          end
        end
      elsif !layers[current_layer + 1].nil?
        puts "creating new task with title Task #{current_task_id} as postreq of #{task.title} - current layer: #{current_layer}"
        tmp_task = Task.create!(
          title: "Task #{current_task_id}",
          list:  generic_user_list
        )
        tmp_task.save!
        current_task_id += 1
        layers[current_layer + 1].push(tmp_task)
        rule = TaskHardRequisite.new(
          pre:  task,
          post: tmp_task
        )
        rule.save!(validate: false)
      end
    end
  end
  current_layer += 1
  next unless current_layer >= layers_count
  break if Task.where(list: generic_user_list).count >= tasks_count

  current_layer = 1
end

puts "Total Size: #{Task.where(list: generic_user_list).count}"
# rubocop:enable Metrics, Layout

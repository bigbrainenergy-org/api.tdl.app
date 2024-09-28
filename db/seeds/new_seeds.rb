# rubocop:disable Layout
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

# total tasks to add for the user
task_count = 1000 # default: 10000

# not used yet - TODO
(task_count.to_f * 0.4).to_i # default: (task_count.to_f * 0.4).to_i

# from the task at layer zero to the deepest task, how long is that chain of tasks?
max_dependency_depth = (task_count.to_f * 0.003).to_i # default: (task_count.to_f * 0.003).to_i

# how chonky is the chonkiest, give or take?
# - can still have extra rules added in the final step of seeding
max_postreqs_width = (task_count.to_f * 0.003).to_i # default: (task_count.to_f * 0.003).to_i

# how many chonky tasks are there?
tasks_at_max_width = (task_count.to_f / 100).to_i # default: (task_count.to_f / 100).to_i

# how many rules in total?
total_rules_count = task_count * 2 # default: task_count * 2
print_interval = (task_count / 42)

proc = Procedure.create!(
  user:  generic_user,
  title: 'Daily Routine',
  icon:  'local_offer',
  color: '#FF0000'
)

# make all tasks in bulk

task_count.times do |n|
  puts "Creating task #{n + 1}" if ((n + 1) % print_interval).zero?
  tmp_task = Task.create!(
    title: "Task #{n}",
    list:  generic_user_list
  )
  tmp_task.procedures.push(proc) if (n % 1000).zero?
  tmp_task.save!
end

# make strings of tasks - ensure chains of tasks reach the desired depth

combo_breaker = 0

loop do
  random_task_depth = rand(1..max_dependency_depth)
  all_tasks_randomized = Task.uncached do
    Task.where(list: generic_user_list).where.missing(:hard_postreqs).order('RANDOM()')
  end
  random_tasks = all_tasks_randomized.first(random_task_depth)
  break unless random_tasks.length == random_task_depth

  puts "making chain #{random_tasks.length} deep - #{all_tasks_randomized.length} remaining"
  random_tasks.each_cons(2) do |task, next_task|
    rule = TaskHardRequisite.new(
      pre:  task,
      post: next_task
    )
    # should be unnecessary but eh
    if rule.valid?
      rule.save!
      combo_breaker = 0
      break
    end
    if combo_breaker >= 100
      puts 'C-C-C-COMBO BREAKER!'
      raise StandardError, 'Something broke while generating the rules'
    else
      combo_breaker += 1
      puts "#{combo_breaker}x COMBO"
    end
  end
end

# make the chonky tasks

tasks_to_make_max_width = Task.uncached do
  Task.where(list: generic_user_list).order('RANDOM()').first(tasks_at_max_width)
end

tasks_to_make_max_width.each do |big_task|
  loop do
    random_postreqs = Task.uncached do
      Task.where(list: generic_user_list).order('RANDOM()').first(max_postreqs_width)
    end
    random_postreqs.each do |post_task|
      rule = TaskHardRequisite.new(
        pre:  big_task,
        post: post_task
      )
      rule.save! if rule.valid?
    end
    break unless big_task.hard_postreqs.length < max_postreqs_width
  end
end

# make the misc rules

combo_breaker = 0

total_rules_count.times do |n|
  puts "Creating rule #{n + 1}" if ((n + 1) % print_interval).zero?
  loop do
    random_tasks = Task.uncached do
      Task.where(list: generic_user_list).order('RANDOM()').first(2)
    end
    rule = TaskHardRequisite.new(
      pre:  random_tasks.first,
      post: random_tasks.second
    )

    if rule.valid?
      rule.save!
      combo_breaker = 0
      break
    end

    if combo_breaker >= 100
      puts 'C-C-C-COMBO BREAKER!'
      raise StandardError, 'Something broke while generating the rules'
    else
      combo_breaker += 1
      puts "#{combo_breaker}x COMBO"
    end
  end
end

# TODO, use each_cons instead of each.
# total_rules_count.times do |n|
#   puts "Creating rule #{n + 1}" if ((n + 1) % print_interval).zero?
#   loop do
#     random_tasks = Task.uncached do
#       Task.where(list: generic_user_list).order('RANDOM()')
#     end
#     # refactoring real quick to .each_cons(2)

#     random_tasks.each_cons(2) do |task, next_task|
#       rule = TaskHardRequisite.new(
#         pre: task,
#         post: next_task
#       )
#       if rule.valid?
#         rule.save!
#         combo_breaker = 0
#       end

#       if combo_breaker >= 100
#         puts 'C-C-C-COMBO BREAKER!'
#         raise StandardError, 'Something broke while generating the rules'
#       else
#         combo_breaker += 1
#         puts "#{combo_breaker}x COMBO"
#       end
#     end
#     break unless TaskHardRequisite.where().count < total_rules_count
#   end
# end
# rubocop:enable Layout

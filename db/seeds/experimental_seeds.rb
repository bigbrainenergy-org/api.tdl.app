generic_user = User.create!(
  username: 'user',
  given_name: 'John',
  family_name: 'Smith',
  email: 'username@domain',
  password: 'correcthorsebatterystaple',
  terms_and_conditions: Time.current
)

generic_user_list = List.create!(title: 'default list', user: generic_user)
generic_user.update!(default_list: generic_user_list)

# total tasks to add for the user
task_count = 10000 # default: 10000

# not used yet - TODO
incomplete_task_count = 4000 # default: (task_count.to_f * 0.4).to_i

# from the task at layer zero to the deepest task, how long is that chain of tasks?
max_dependency_depth = 30 # default: (task_count.to_f * 0.003).to_i

# how chonky is the chonkiest, give or take?
# - can still have extra rules added in the final step of seeding
max_postreqs_width = 30 # default: (task_count.to_f * 0.003).to_i

# how many chonky tasks are there?
tasks_at_max_width = (task_count.to_f / 100).to_i # default: (task_count.to_f / 100).to_i

# TODO: make seeds that utilize creating new tasks instead of making all tasks upfront and doing costly validity checks on all rules created later.
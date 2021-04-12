void_xxx = User.create!(
  username:             'void_xxx',
  given_name:           'Kurt',
  family_name:          'Apple',
  email:                'username@void.xxx',
  password:             'correcthorsebatterystaple',
  terms_and_conditions: Time.current
)

User.create!(
  username:             'awesome',
  given_name:           'awesome',
  family_name:          'username',
  email:                'username@awesome',
  password:             'awesomelongpassword',
  terms_and_conditions: DateTime.new(1970, 1, 2, 1)
)

inbox = List.create!(
  user:  void_xxx,
  title: 'Inbox'
)

# TODO: Do some seeds

task_count = 100
rule_count = (task_count.to_f * 1.5).to_i
print_interval = (task_count / 10)

task_count.times do |n|
  puts "Creating task #{n + 1}" if ((n + 1) % print_interval).zero?
  Task.create!(
    title: "Task #{n}",
    list:  inbox,
    user:  void_xxx
  )
end

combo_breaker = 0

rule_count.times do |n|
  puts "Creating rule #{n + 1}" if ((n + 1) % print_interval).zero?
  loop do
    random_tasks =
      Task.uncached { Task.where(user: void_xxx).order('RANDOM()').first(2) }
    rule = Rule.new(pre: random_tasks.first, post: random_tasks.second)

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

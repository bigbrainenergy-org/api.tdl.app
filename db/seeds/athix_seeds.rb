athix = User.create!(
  username:             'athix',
  given_name:           'Josh',
  family_name:          'Buker',
  email:                'athix@tdl.app',
  password:             'correcthorsebatterystaple',
  time_zone:            'Pacific Time (US & Canada)',
  terms_and_conditions: Time.current
)

Struct.new('Tag', :title, :color)

tags = []

tags << Struct::Tag.new('Priority', '#fcf949')
tags << Struct::Tag.new('Career',   '#b63ec1')
tags << Struct::Tag.new('@Home',    '#63ed5a')
tags << Struct::Tag.new('@Town',    '#f29010')
tags << Struct::Tag.new('@Phone',   '#3295ff')
tags << Struct::Tag.new('@Office',  '#ea2035')
tags << Struct::Tag.new('@Laptop',  '#6ce2cf')

tags.each do |tag|
  Tag.create!(
    user:  athix,
    title: tag.title,
    color: tag.color
  )
end

lists = [
  'Inbox',
  'Grocery List',
  'Action Pending',
  'Shopping List',
  'Clothes',
  'Waiting',
  'Blocked'
]

lists.each do |list|
  List.create!(
    user:  athix,
    title: list
  )
end

inbox = athix.lists.find_by(title: 'Inbox')
priority = athix.tags.find_by(title: 'Priority')
career = athix.tags.find_by(title: 'Career')

# TODO: Make this more realistic

10.times do |n|
  task = Task.create!(
    title: "Task #{n}",
    list:  inbox,
    user:  athix
  )
  Tagging.create!(task: task, tag: priority)
  Tagging.create!(task: task, tag: career) if [true, false].sample
  3.times do |m|
    subtask = Task.create!(
      title: "Set #{n} Subtask #{m}",
      list:  inbox,
      user:  athix
    )
    Rule.create!(pre: task, post: subtask)
    Tagging.create!(task: subtask, tag: career) if [true, false].sample
    2.times do |k|
      subsub = Task.create!(
        title: "Set #{n} Subset #{m} Subtask #{k}",
        list:  inbox,
        user:  athix
      )
      Rule.create!(pre: subtask, post: subsub)
      Tagging.create!(task: subsub, tag: career) if [true, false].sample
    end
  end
end

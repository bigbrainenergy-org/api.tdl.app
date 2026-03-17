json.array! @schedules do |schedule|
  json.call(schedule, :id, :user_id, :title, :default, :blocks)
end

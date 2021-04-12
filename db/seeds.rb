ApplicationRecord.transaction do
  seed_file = Rails.root.join('db', 'seeds', "#{Rails.env.downcase}.rb")
  puts "Loading seed file from: #{seed_file}"
  load(seed_file)
rescue LoadError
  puts "No seeds file for the #{Rails.env.downcase} environment, skipping."
end

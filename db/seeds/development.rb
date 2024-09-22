neo_seeds = Rails.root.join('db/seeds/neo_seeds.rb')
puts "Loading seed file from: #{neo_seeds}"
load(neo_seeds)

# void_xxx_seeds = Rails.root.join('db/seeds/void_xxx_seeds.rb')
# puts "Loading seed file from: #{void_xxx_seeds}"
# load(void_xxx_seeds)

generic_user_seeds = Rails.root.join('db/seeds/experimental_seeds.rb')
puts "Loading seed file from: #{generic_user_seeds}"
load(generic_user_seeds)
athix_seeds = Rails.root.join('db/seeds/athix_seeds.rb')
puts "Loading seed file from: #{athix_seeds}"
load(athix_seeds)

void_xxx_seeds = Rails.root.join('db/seeds/void_xxx_seeds.rb')
puts "Loading seed file from: #{void_xxx_seeds}"
load(void_xxx_seeds)

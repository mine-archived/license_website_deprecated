require_relative '../../config/environment'

namespace :parse_pack do
  task :start => :environment do
    a = Product.all
    puts a
  end

end

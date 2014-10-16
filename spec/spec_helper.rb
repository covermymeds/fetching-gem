require "fetching"
require "rspec/autorun"
require "pathname"

Pathname(__FILE__).dirname.join("support").each_child { |f| require f }

RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  # config.order = "random"
  config.color = :enabled
end

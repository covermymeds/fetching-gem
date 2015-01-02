require 'fetching'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  if ENV['CI']
    config.before(:example, :focus) { fail 'Should not commit focused specs' }
  else
    config.filter_run :focus
    config.run_all_when_everything_filtered = true
  end

  config.disable_monkey_patching!

  config.warnings = true

  config.order = :random

  Kernel.srand config.seed
end

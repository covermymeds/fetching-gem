guard :rubocop, cli: ['--display-cop-names'] do
  watch(%r{.+\.rb$})
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

rspec_opts = {
  cmd:             'bundle exec rspec',
  all_on_start:    true,
  all_after_pass:  true,
  failed_mode:     :keep
}

guard :rspec, rspec_opts do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }

  watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$}) do |m|
    "spec/#{m[1]}#{m[2]}_spec.rb"
  end

  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
    [
      "spec/routing/#{m[1]}_routing_spec.rb",
      "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
      "spec/acceptance/#{m[1]}_spec.rb"
    ]
  end
  watch(%r{^spec/support/(.+)\.rb$})                  { 'spec' }
  watch('config/routes.rb')                           { 'spec/routing' }
  watch('app/controllers/application_controller.rb')  { 'spec/controllers' }

  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$}) do |m|
    "spec/features/#{m[1]}_spec.rb"
  end

  watch(%r{^spec/acceptance/(.+)\.feature$})
  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
  end
end

require 'bundler'
Bundler::GemHelper.install_tasks

begin
  require "rspec/core/rake_task"
  require "rspec/core/version"

  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w(--color)
  end
rescue LoadError
  # rspec not loaded, tasks not available
  desc "[RSpec failed to load] Run all examples"
  task :spec do
    fail "RSpec failed to load, this task can't be run"
  end
end

desc "Alias for spec"
task :test => :spec

begin
  require "yard"

  YARD::Rake::YardocTask.new :doc do |yard|
    yard.files = Dir.glob("lib/**/*.rb")
  end
rescue LoadError
  puts "failed to load yard"
end

require "bundler/gem_tasks"
task :default => [:test]


task :build do
  system "gem build oriental.gemspec"
end

task :release => :build do
  system "gem push oriental-#{Oriental::VERSION}"
end

task :install do
  system "gem install oriental#{Oriental::Version}"
end

test_tasks = ['test:all']
desc "Run all tests"
task :test => test_tasks


namespace :test do
  desc "Run all tests and check coverage"
  task :all do
    $: << 'lib'
    require 'simplecov'

    SimpleCov.start do
      add_filter "test"
      command_name 'Mintest'
    end

    $LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__))
    require_relative 'lib/oriental'
    require 'test/test_helper'

    Dir['./test/**/*_test.rb'].each { |test| require test }
  end
end

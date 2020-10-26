# frozen_string_literal: true

require 'rspec/core/rake_task'
require 'yard'
require 'coveralls/rake/task'

RSpec::Core::RakeTask.new(:test)

task default: :test

YARD::Rake::YardocTask.new

Coveralls::RakeTask.new

task test_with_coveralls: [:test, 'coveralls:push']

# frozen_string_literal: true

require "bundler/setup"
Bundler.require :tools

require "simplecov"

unless ENV["NO_COVERAGE"]
  SimpleCov.start do
    enable_coverage :branch
    add_filter %r(^/spec/)
    minimum_coverage_by_file line: 95, branch: 95
  end
end

require "git/lint"
require "refinements"
require "git_plus/spec/shared_contexts/temp_dir"
require "git_plus/spec/shared_contexts/git_commit"
require "git_plus/spec/shared_contexts/git_repo"

using Refinements::Pathnames

Pathname.require_tree __dir__, "support/shared_contexts/**/*.rb"
Pathname.require_tree __dir__, "support/shared_examples/**/*.rb"

# Ensure CI environments are disabled for local testing purposes.
ENV["CIRCLECI"] = "false"

RSpec.configure do |config|
  config.color = true
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
  config.filter_run_when_matching :focus
  config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end

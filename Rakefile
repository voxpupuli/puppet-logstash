require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

PuppetLint::RakeTask.new :lint do |config|
  config.disable_checks = ['80chars']
  config.fail_on_warnings = true
  config.with_context = true
  config.ignore_paths = exclude_paths
  config.log_format = log_format
end

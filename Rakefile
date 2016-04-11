require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

#PuppetDocLint.configuration.ignore_paths = exclude_paths

#require 'puppet-syntax/tasks/puppet-syntax'

#PuppetSyntax.exclude_paths = exclude_paths
#PuppetSyntax.future_parser = true if ENV['FUTURE_PARSER'] == 'true'

#PuppetLint.configuration.ignore_paths = exclude_paths
#PuppetLint.configuration.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"

PuppetLint::RakeTask.new :lint do |config|
  config.disable_checks = ['80chars']
  config.fail_on_warnings = true
  config.with_context = true
  config.ignore_paths = exclude_paths
  config.log_format = log_format
end

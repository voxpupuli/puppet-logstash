.DEFAULT_GOAL := .vendor

.vendor:
	bundle install --path .vendor


.PHONY: test-rspec
test-rspec: .vendor
	bundle exec rake lint
#	bundle exec rake validate
#	bundle exec rake spec_verbose

.PHONY: deps
deps:
	bundle install --path .vendor
	puppet module install puppetlabs/apt --target-dir spec/fixtures/modules
	puppet module install puppetlabs/stdlib --target-dir spec/fixtures/modules
	puppet module install electrical/file_concat --target-dir spec/fixtures/modules
	touch spec/fixtures/manifests/site.pp

.PHONY: test-rspec
test-rspec: deps
	bundle exec rake lint
	bundle exec rake validate
	bundle exec rake spec_verbose

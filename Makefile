deps:
	bundle install --path .vendor
	puppet module install puppetlabs/apt --target-dir spec/fixtures/modules
	puppet module install puppetlabs/stdlib --target-dir spec/fixtures/modules
	puppet module install electrical/file_concat --target-dir spec/fixtures/modules
	touch spec/fixtures/manifests/site.pp
	(cd spec/fixtures/artifacts/ && wget --no-clobber https://download.elastic.co/logstash/logstash/packages/centos/logstash-1.5.5-1.noarch.rpm)


test-rspec: deps
	bundle exec rake lint
	bundle exec rake validate
	bundle exec rake spec_verbose

clean:
	rm spec/fixtures/artifacts/logstash*

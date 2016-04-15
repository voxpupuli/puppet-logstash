#	opensuse-121 \
#       sles-11sp3 \

distros = \
	centos-6 \
	centos-7 \
	debian-7 \
	debian-8 \
	opensuse-13 \
	ubuntu-1204 \
	ubuntu-1404

deps:
	bundle install --path .vendor
	puppet module install puppetlabs/apt --target-dir spec/fixtures/modules
	puppet module install puppetlabs/stdlib --target-dir spec/fixtures/modules
	puppet module install electrical/file_concat --target-dir spec/fixtures/modules
	puppet module install darin/zypprepo --target-dir spec/fixtures/modules
	touch spec/fixtures/manifests/site.pp

lint:
	bundle exec rake lint
	bundle exec rake validate
	# bundle exec rubocop spec Rakefile

test-unit: deps lint
	bundle exec rake spec_verbose

test-acceptance: $(distros)

$(distros):
	BEAKER_set=$@ bundle exec rake beaker

clean:
	rm -f spec/fixtures/artifacts/logstash*

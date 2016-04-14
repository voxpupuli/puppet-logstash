distros = \
	centos-6 \
	centos-7 \
	debian-7 \
	debian-8 \
	opensuse-121 \
	opensuse-131 \
	sles-11sp3 \
	ubuntu-server-1204 \
	ubuntu-server-1210 \
	ubuntu-server-1304 \
	ubuntu-server-1310 \
	ubuntu-server-1404

deps:
	bundle install --path .vendor
	puppet module install puppetlabs/apt --target-dir spec/fixtures/modules
	puppet module install puppetlabs/stdlib --target-dir spec/fixtures/modules
	puppet module install electrical/file_concat --target-dir spec/fixtures/modules
	touch spec/fixtures/manifests/site.pp

lint:
	bundle exec rake lint
	bundle exec rake validate
	bundle exec rubocop

test-rspec: deps lint
	bundle exec rake spec_verbose

test-beaker: $(distros)

$(distros):
	BEAKER_set=$@-x64 BEAKER_ls_version=1.5.6-1 bundle exec rspec spec/acceptance/

clean:
	rm -f spec/fixtures/artifacts/logstash*

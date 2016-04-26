# This Vagrant file is provided as a convenience for development and
# exploratory testing of puppet-logstash. It's not used by the formal
# testing framwork, it's just for hacking.
#
# See `CONTRIBUTING.md` for details on formal testing.

shell_script = <<-END
  apt-get update
  apt-get --assume-yes upgrade
  puppet module install puppetlabs-apt
  puppet module install puppetlabs-stdlib
  puppet module install electrical-file_concat
  END

module_root = '/etc/puppetlabs/code/environments/production/modules/logstash'

Vagrant.configure(2) do |config|
  config.vm.box = 'puppetlabs/ubuntu-14.04-64-puppet'
  config.vm.provision('shell', inline: shell_script)
  %w(manifests templates).each do |dir|
    config.vm.synced_folder(dir, "#{module_root}/#{dir}")
  end
end

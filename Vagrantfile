# This Vagrant file is provided as a convenience for development and
# exploratory testing of puppet-logstash. It's not used by the formal
# testing framwork, it's just for hacking.
#
# See `CONTRIBUTING.md` for details on formal testing.

shell_script = <<-END
  if [[ ! -L /usr/local/bin/puppet ]]; then
    for mod in puppetlabs-apt puppetlabs-stdlib electrical-file_concat; do
      puppet module install --target-dir=/opt/puppetlabs/puppet/modules $mod
    done

    for exe in facter puppet hiera; do
      ln -s /opt/puppetlabs/bin/$exe /usr/local/bin
    done
  fi

  puppet apply -e 'class {"logstash": manage_repo => true, java_install => true}'
  END

module_root = '/etc/puppetlabs/code/environments/production/modules/logstash'

Vagrant.configure(2) do |config|
  config.vm.box = 'puppetlabs/debian-8.2-64-puppet'
  config.vm.provision('shell', inline: shell_script)
  %w(manifests templates files).each do |dir|
    config.vm.synced_folder(dir, "#{module_root}/#{dir}")
  end
end

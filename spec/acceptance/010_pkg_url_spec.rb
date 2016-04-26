
require 'spec_helper_acceptance'

if fact('osfamily') != 'Suse'
  describe 'class logstash' do
    package_name = 'logstash'
    service_name = 'logstash'
    pid_file = '/var/run/logstash.pid'

    local_package_path = "/tmp/#{logstash_package_filename}"

    shell("mkdir -p #{default['distmoduledir']}/another/files")
    shell("cp #{local_package_path} #{default['distmoduledir']}/another/files/#{logstash_package_filename}")

    context 'install via http resource' do
      it 'should run successfully' do
        manifest = <<-END
        class { 'logstash':
          package_url => '#{logstash_package_url}',
          java_install => true
        }

        logstash::configfile { 'basic_config':
          content => 'input { tcp { port => 2000 } } output { null { } } '
        }
        END

        apply_manifest(manifest, catch_failures: true)
        sleep 5
      end

      describe package(package_name) do
        it { should be_installed }
      end

      describe file(pid_file) do
        it { should be_file }
        its(:content) { should match(/^[0-9]+$/) }
      end

      it 'should only have 1 logstash process running' do
        shell('test $(ps aux | grep -w -- logstash | grep -v grep | wc -l) -eq 1')
      end
    end

    context 'ensure absent' do
      it 'should run successfully' do
        apply_manifest("class { 'logstash': ensure => absent }", catch_failures: true)
        sleep 5
      end

      describe package(package_name) do
        it { should_not be_installed }
      end

      describe service(service_name) do
        it { should_not be_running }
        it do
          if fact('lsbdistdescription') =~ /debian.*jessie/i
            pending('https://github.com/elastic/puppet-logstash/issues/266')
          end
          should_not be_enabled
        end
      end
    end

    context 'install via local file resource' do
      manifest = <<-END
        class { 'logstash':
          package_url => 'file:#{local_package_path}',
          java_install => true
        }

        logstash::configfile { 'basic_config':
          content => 'input { tcp { port => 2000 } } output { null { } } '
        }
        END

      it 'should run successfully' do
        apply_manifest(manifest, catch_failures: true)
        sleep 5
      end

      it 'should not cause any change when run a second time' do
        if fact('lsbdistdescription') =~ /debian.*jessie/i
          pending('https://github.com/elastic/puppet-logstash/issues/266')
        end
        puppet_run = apply_manifest(manifest, catch_failures: true)
        expect(puppet_run.exit_code).to(be_zero)
      end

      describe package(package_name) do
        it { should be_installed }
      end

      describe file(pid_file) do
        it { should be_file }
        its(:content) { should match(/^[0-9]+$/) }
      end

      it 'should only have 1 logstash process running' do
        shell('test $(ps aux | grep -w -- logstash | grep -v grep | wc -l) -eq 1')
      end
    end

    context 'install via puppet resource' do
      manifest = <<-END
        class { 'logstash':
          package_url => 'puppet:///modules/another/#{logstash_package_filename}',
          java_install => true
        }

        logstash::configfile { 'basic_config':
          content => 'input { tcp { port => 2000 } } output { null { } } '
        }
        END

      it 'should run successfully' do
        apply_manifest(manifest, :catch_failures => true)
        sleep 5
      end

      it 'should not cause any change when run a second time' do
        if fact('lsbdistdescription') =~ /debian.*jessie/i
          pending('https://github.com/elastic/puppet-logstash/issues/266')
        end
        puppet_run = apply_manifest(manifest, catch_failures: true)
        expect(puppet_run.exit_code).to(be_zero)
      end

      describe package(package_name) do
        it { should be_installed }
      end

      describe file(pid_file) do
        it { should be_file }
        its(:content) { should match(/^[0-9]+$/) }
      end

      it 'should only have 1 logstash process running' do
        shell('test $(ps aux | grep -w -- logstash | grep -v grep | wc -l) -eq 1')
      end
    end
  end
end

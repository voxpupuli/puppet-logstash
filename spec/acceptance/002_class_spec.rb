require 'spec_helper_acceptance'

describe 'class logstash' do
  package_name = 'logstash'
  service_name = 'logstash'
  pid_file     = '/var/run/logstash.pid'

  context 'with default parameters' do
    manifest = <<-END
      class { 'logstash':
         manage_repo => true,
         repo_version => '#{REPO_VERSION}',
         java_install => true
      }

      logstash::configfile { 'basic_config':
        content => 'input { tcp { port => 2000 } } output { null { } }'
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

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

    describe package(package_name) do
      it { should be_installed }
    end

    describe file(pid_file) do
      it { should be_file }
      its(:content) { should match(/^[0-9]+$/) }
    end

    it 'should install the correct logstash version' do
      expect(shell('/opt/logstash/bin/logstash --version').stdout).to eq("logstash #{LS_VERSION}\n")
    end

    it 'should only have 1 logstash process running' do
      shell('test $(ps aux | grep -w -- logstash | grep -v grep | wc -l) -eq 1')
    end
  end

  describe 'ensure absent' do
    it 'should run successfully' do
      pp = "class { 'logstash': ensure => 'absent' }"
      apply_manifest(pp, catch_failures: true)
    end

    describe file('/etc/logstash') do
      it { should_not be_directory }
    end

    describe service(service_name) do
      it do
        if fact('lsbdistdescription') =~ /debian.*jessie/i
          pending('https://github.com/elastic/puppet-logstash/issues/266')
        end
        should_not be_enabled
      end

      it { should_not be_running }
    end

    describe package(package_name) do
      it { should_not be_installed }
    end
  end
end


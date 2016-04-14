require 'spec_helper_acceptance'
require 'semantic'

version = Semantic::Version.new(LS_VERSION)
if version < Semantic::Version.new('1.5.0')
  describe 'logstash-contrib package' do
    service_name    = 'logstash'
    package_name    = 'logstash'
    package_contrib = 'logstash-contrib'
    pid_file        = '/var/run/logstash.pid'

    describe 'install' do
      context 'via repository' do
        it 'should run successfully' do
          manifest = <<-END
            class { 'logstash':
              manage_repo => true,
              repo_version => '#{REPO_VERSION}',
              java_install => true,
              install_contrib => true
            }

            logstash::configfile { 'basic_config':
              content => 'input { tcp { port => 2000 } } output { null { } } '
            }
            END

          # Run it twice and test for idempotency
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

        describe service(service_name) do
          it { should be_enabled }
          it { should be_running }
        end

        describe package(package_name) do
          it { should be_installed }
        end

        describe package(package_contrib) do
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
end

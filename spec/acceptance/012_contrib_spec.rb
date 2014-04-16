require 'spec_helper_acceptance'

if fact('osfamily') != 'Suse'
describe "Contrib tests:" do

  cluster_name = SecureRandom.hex(10)

  case fact('osfamily')
    when 'RedHat'
			service_name    = 'logstash'
			package_name    = 'logstash'
			package_contrib = 'logstash-contrib'
			pid_file        = '/var/run/logstash/logstash.pid'
    when 'Debian'
			service_name    = 'logstash'
			package_name    = 'logstash'
			package_contrib = 'logstash-contrib'
			pid_file        = '/var/run/logstash.pid'
  end


  describe "Install the contrib package" do

    context "Change the defaults file" do
     it 'should run successfully' do
				pp = "class { 'logstash': manage_repo => true, repo_version => '1.4', java_install => true, install_contrib => true } }
              logstash::configfile { 'basic_config': content => 'input { tcp { port => 2000 } } output { stdout { } } ' }
             "

        # Run it twice and test for idempotency
        apply_manifest(pp, :catch_failures => true)
        sleep 10
        expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      end
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
				its(:content) { should match /[0-9]+/ }
			end

			describe file('/opt/logstash/vendor/logstash/logstash-contrib-1.4.0/') do
				it { should be_directory }
			end
  end
end
end

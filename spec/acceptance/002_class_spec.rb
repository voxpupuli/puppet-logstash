require 'spec_helper_acceptance'

describe "logstash class:" do

  case fact('osfamily')
  when 'RedHat'
    package_name = 'logstash'
    service_name = 'logstash'
    pid_file     = '/var/run/logstash.pid'
  when 'Debian'
    package_name = 'logstash'
    service_name = 'logstash'
    pid_file     = '/var/run/logstash.pid'
  end

  describe "default parameters" do

    it 'should run successfully' do
      pp = "class { 'logstash': manage_repo => true, repo_version => '1.4', java_install => true }
            logstash::configfile { 'basic_config': content => 'input { tcp { port => 2000 } } output { null { } } ' }
           "

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep 5
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      sleep 5
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

    it 'Show all running logstash processes' do
      shell('ps auxfw | grep logstash | grep -v grep')
    end

    it "should only have 1 logstash process running" do
      shell('test $(ps aux | grep -w -- logstash | grep -v grep | wc -l) -eq 1')
    end
  end

end

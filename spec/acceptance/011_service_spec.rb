require 'spec_helper_acceptance'

describe "Service tests:" do

  cluster_name = SecureRandom.hex(10)

  case fact('osfamily')
    when 'RedHat'
      defaults_file = '/etc/sysconfig/logstash'
      service_name  = 'logstash'
      package_name  = 'logstash'
      pid_file      = '/var/run/logstash.pid'
    when 'Debian'
      defaults_file = '/etc/default/logstash'
      service_name  = 'logstash'
      package_name  = 'logstash'
      pid_file      = '/var/run/logstash.pid'
    when 'Suse'
      defaults_file = '/etc/sysconfig/logstash'
  end


  describe "Make sure we can manage the defaults file" do

    context "Change the defaults file" do
      it 'should run successfully' do
        pp = "class { 'logstash': manage_repo => true, repo_version => '1.4', java_install => true, init_defaults => { 'LS_USER' => 'root', 'LS_JAVA_OPTS' => '\"-Djava.io.tmpdir=$HOME -XX:+UseTLAB\"' } }
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

      describe file(defaults_file) do
        its(:content) { should match /^LS_USER=root/ }
        its(:content) { should match /^LS_JAVA_OPTS="-Djava.io.tmpdir=\$HOME -XX:\+UseTLAB"/ }
        its(:content) { should_not match /^LS_USER=logstash/ }
      end

      it 'Show all running logstash processes' do
        shell('ps auxfw | grep logstash | grep -v grep')
      end

      it "should only have 1 logstash process running" do
        shell('test $(ps aux | grep -w -- logstash | grep -v grep | wc -l) -eq 1')
      end

    end
  end
end

require 'spec_helper_acceptance'

describe "logstash class:" do

  case fact('osfamily')
  when 'RedHat'
    package_name = 'logstash'
    service_name = 'logstash'
  when 'Debian'
    package_name = 'logstash'
    service_name = 'logstash'
  end

  describe "default parameters" do

    it 'should run successfully' do
      pp = "class { 'logstash': manage_repo => true, repo_version => '1.3', java_install => true, init_defaults => { 'START' => 'true', 'LS_JAR' => '/opt/logstash/logstash.jar', 'LS_JAVA_OPTS' => '\"-Xmx256m -Djava.io.tmpdir=/var/lib/logstash/\"' } }
            logstash::configfile { 'basic_config': content => 'input { tcp { port => 2000 } } output { stdout { } } ' }
           "

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep 30
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
    end

    describe service(service_name) do
      it { should be_enabled }
      it { should be_running } 
    end

    describe package(package_name) do
      it { should be_installed }
    end

  end

end

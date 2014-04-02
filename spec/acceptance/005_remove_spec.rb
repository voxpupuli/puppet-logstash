require 'spec_helper_acceptance'

  case fact('osfamily')
  when 'RedHat'
    package_name = 'logstash'
    service_name = 'logstash'
  when 'Debian'
    package_name = 'logstash'
    service_name = 'logstash'
  end

describe "module removal" do

  it 'should run successfully' do
    pp = "class { 'logstash': ensure => 'absent' }"

    # Run it twice and test for idempotency
    apply_manifest(pp, :catch_failures => true)

  end

  describe file('/etc/logstash') do
    it { should_not be_directory }
  end

  describe service(service_name) do
    it { should_not be_enabled }
    it { should_not be_running } 
  end

  describe package(package_name) do
    it { should_not be_installed }
  end

end

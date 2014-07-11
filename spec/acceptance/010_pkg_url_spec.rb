require 'spec_helper_acceptance'

if fact('osfamily') != 'Suse'

describe "Logstash class:" do

  case fact('osfamily')
  when 'RedHat'
    package_name = 'logstash'
    service_name = 'logstash'
    url          = 'http://download.elasticsearch.org/logstash/logstash/packages/centos/logstash-1.4.1-1_bd507eb.noarch.rpm'
    local        = '/tmp/logstash-1.4.1-1_bd507eb.noarch.rpm'
    puppet       = 'logstash-1.4.1-1_bd507eb.noarch.rpm'
    pid_file     = '/var/run/logstash.pid'
  when 'Debian'
    package_name = 'logstash'
    service_name = 'logstash'
    url          = 'http://download.elasticsearch.org/logstash/logstash/packages/debian/logstash_1.4.1-1-bd507eb_all.deb'
    local        = '/tmp/logstash_1.4.1-1-bd507eb_all.deb'
    puppet       = 'logstash_1.4.1-1-bd507eb_all.deb'
    pid_file     = '/var/run/logstash.pid'
  end

  shell("mkdir -p #{default['distmoduledir']}/another/files")
  shell("cp #{local} #{default['distmoduledir']}/another/files/#{puppet}")

  context "install via http resource" do

    it 'should run successfully' do
      pp = "class { 'logstash': package_url => '#{url}', java_install => true }
            logstash::configfile { 'basic_config': content => 'input { tcp { port => 2000 } } output { null { } } ' }
           "

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep 5
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      sleep 5
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

  context "Clean" do
    it 'should run successfully' do
      apply_manifest("class { 'logstash': ensure => absent }", :catch_failures => true)
      sleep 5
    end

    describe package(package_name) do
      it { should_not be_installed }
    end

    describe service(service_name) do
      it { should_not be_enabled }
      it { should_not be_running }
    end

  end

  context "Install via local file resource" do

    it 'should run successfully' do
      pp = "class { 'logstash': package_url => 'file:#{local}', java_install => true }
            logstash::configfile { 'basic_config': content => 'input { tcp { port => 2000 } } output { null { } } ' }
           "

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep 5
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      sleep 5

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

  context "Clean" do
    it 'should run successfully' do
      apply_manifest("class { 'logstash': ensure => absent }", :catch_failures => true)
      sleep 5
    end

    describe package(package_name) do
      it { should_not be_installed }
    end

    describe service(service_name) do
      it { should_not be_enabled }
      it { should_not be_running }
    end

  end

  context "Install via Puppet resource" do

    it 'should run successfully' do
      pp = "class { 'logstash': package_url => 'puppet:///modules/another/#{puppet}', java_install => true }
            logstash::configfile { 'basic_config': content => 'input { tcp { port => 2000 } } output { null { } } ' }
           "

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      sleep 5
      expect(apply_manifest(pp, :catch_failures => true).exit_code).to be_zero
      sleep 5

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

  context "Clean" do
    it 'should run successfully' do
      apply_manifest("class { 'logstash': ensure => absent }", :catch_failures => true)
      sleep 5
    end

    describe package(package_name) do
      it { should_not be_installed }
    end

    describe service(service_name) do
      it { should_not be_enabled }
      it { should_not be_running }
    end

  end

end

end

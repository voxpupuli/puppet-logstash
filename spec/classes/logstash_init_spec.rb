require 'spec_helper'

describe 'logstash', :type => 'class' do

  context "With a package" do

    context "On Debian OS" do
      let :facts do {
        :operatingsystem => 'Debian'
      } end
   
      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }
      it { should contain_file('/etc/init.d/logstash').with(:ensure => 'absent') }
    end

    context "On Ubuntu OS" do
      let :facts do {
        :operatingsystem => 'Ubuntu'
      } end

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }
      it { should contain_file('/etc/init.d/logstash').with(:ensure => 'absent') }

    end

    context "On CentOS OS " do
      let :facts do {
        :operatingsystem => 'CentOS'
      } end

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }
      it { should contain_file('/etc/init.d/logstash').with(:ensure => 'absent') }

    end

    context "On RedHat OS " do
      let :facts do {
        :operatingsystem => 'Redhat'
      } end

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }
      it { should contain_file('/etc/init.d/logstash').with(:ensure => 'absent') }

    end

    context "On Fedora OS " do
      let :facts do {
        :operatingsystem => 'Fedora'
      } end

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }
      it { should contain_file('/etc/init.d/logstash').with(:ensure => 'absent') }

    end

    context "On Scientific OS " do
      let :facts do {
        :operatingsystem => 'Scientific'
      } end

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }
      it { should contain_file('/etc/init.d/logstash').with(:ensure => 'absent') }

    end

    context "On Amazon OS " do
      let :facts do {
        :operatingsystem => 'Amazon'
      } end

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }
      it { should contain_file('/etc/init.d/logstash').with(:ensure => 'absent') }
  
    end

    context "On an unknown OS" do
      let :facts do {
        :operatingsystem => 'Darwin'
      } end
 
      it { expect { should raise_error(Puppet::Error) } }
    end

    context "With a custom init script" do

      let :facts do {
        :operatingsystem => 'CentOS'
      } end

      let :params do {
        :initfiles => { 'agent' => 'puppet:///path/to/init' }
      } end

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      # service.pp
      it { should contain_service('logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-agent').with(
        :source => 'puppet:///path/to/init',
        :content => nil
      ) }
    end
  end

  context "With custom jar file" do

    context "and built in init script" do

      let :facts do {
        :operatingsystem => 'CentOS'
      } end

      let :params do {
        :provider => 'custom',
        :jarfile => "puppet:///path/to/logstash-1.1.9.jar",
        :installpath => '/opt/logstash'
      } end

      it { should_not contain_package('logstash') }
      it { should contain_file('/etc/init.d/logstash-agent').with(:source => nil) }
      it { should contain_service('logstash-agent') }

    end

    context "and custom init script" do

      let :facts do {
        :operatingsystem => 'CentOS'
      } end

      let :params do {
        :provider => 'custom',
        :jarfile => 'puppet:///path/to/logstash-1.1.9.jar',
        :installpath => '/opt/logstash',
        :initfiles => { 'agent' => 'puppet:///path/to/logstash.init' }
      } end

      it { should_not contain_package('logstash') }
      it { should contain_file('/etc/init.d/logstash-agent').with(
        :source => 'puppet:///path/to/logstash.init')
      }
      it { should contain_service('logstash-agent') }

    end
  end

  context "Do not manage the service" do

    context "with a package" do

      let :facts do {
        :operatingsystem => 'CentOS'
      } end

      let :params do {
        :status => 'unmanaged'
      } end

      it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }

   end

   context "with a jar file" do
   
     let :facts do {
       :operatingsystem => 'CentOS'
     } end

     let :params do {
       :provider => 'custom',
       :jarfile => "puppet:///path/to/logstash-1.1.9.jar",
       :installpath => '/opt/logstash',
       :status => 'unmanaged'
     } end

     it { should_not contain_package('logstash') }
     it { should_not contain_file('/etc/init.d/logstash') }
     it { should_not contain_service('logstash') }
     it { should_not contain_file('/etc/init.d/logstash-agent') }
     it { should_not contain_service('logstash-agent') }

    end
  end

  context "multi-instance tests ( agent and indexer )" do

    let :facts do {
      :operatingsystem => 'CentOS'
    } end

    context "Nothing extra" do

      let :params do {
        :instances => [ 'agent', 'indexer' ]
      } end

      it { should contain_service('logstash-agent') }
      it { should contain_service('logstash-indexer') }

      it { should contain_file('/etc/init.d/logstash-agent') }
      it { should contain_file('/etc/init.d/logstash-indexer') }

      it { should contain_file('/etc/logstash/agent/config') }
      it { should contain_file('/etc/logstash/indexer/config') }

    end

    context "with separate defaults files" do
    
      let :params do {
        :instances => [ 'agent', 'indexer' ],
        :defaultsfiles => { 'agent' => 'puppet:///path/to/agent-defaults', 'indexer' => 'puppet:///path/to/indexer-defaults' }
      } end

      it { should contain_service('logstash-agent') }
      it { should contain_service('logstash-indexer') }

      it { should contain_file('/etc/init.d/logstash-agent').with(:source => nil) }
      it { should contain_file('/etc/init.d/logstash-indexer').with(:soruce => nil) }

      it { should contain_file('/etc/sysconfig/logstash-agent').with(:source => 'puppet:///path/to/agent-defaults') }
      it { should contain_file('/etc/sysconfig/logstash-indexer').with(:source => 'puppet:///path/to/indexer-defaults') }

      it { should contain_file('/etc/logstash/agent/config') }
      it { should contain_file('/etc/logstash/indexer/config') }

    end

    context "with separate init files" do
      let :params do {
        :instances => [ 'agent', 'indexer' ],
        :initfiles => { 'agent' => 'puppet:///path/to/agent-init', 'indexer' => 'puppet:///path/to/indexer-init' }
      } end

      it { should contain_service('logstash-agent') }
      it { should contain_service('logstash-indexer') }

      it { should contain_file('/etc/init.d/logstash-agent').with(:source => 'puppet:///path/to/agent-init') }
      it { should contain_file('/etc/init.d/logstash-indexer').with(:source => 'puppet:///path/to/indexer-init') }
 
      it { should contain_file('/etc/logstash/agent/config') }
      it { should contain_file('/etc/logstash/indexer/config') }

   end

  end

  context "install java" do

    let :params do {
      :java_install => true
    } end

    context "On a Debian OS" do

      let :facts do {
        :operatingsystem => 'Debian'
      } end

      it { should contain_package('openjdk-6-jre-headless') }

    end

    context "On an Ubuntu OS" do

      let :facts do {
        :operatingsystem => 'Ubuntu'
      } end

      it { should contain_package('openjdk-6-jre-headless') }

    end

    context "On a CentOS OS " do

      let :facts do {
        :operatingsystem => 'CentOS'
      } end

      it { should contain_package('java-1.6.0-openjdk') }

    end

    context "On a RedHat OS " do

      let :facts do {
        :operatingsystem => 'Redhat'
      } end

      it { should contain_package('java-1.6.0-openjdk') }

    end

    context "On a Fedora OS " do

      let :facts do {
        :operatingsystem => 'Fedora'
      } end

      it { should contain_package('java-1.6.0-openjdk') }

    end

    context "On a Scientific OS " do

      let :facts do {
        :operatingsystem => 'Scientific'
      } end

      it { should contain_package('java-1.6.0-openjdk') }

    end

    context "On a Amazon OS " do

      let :facts do {
        :operatingsystem => 'Amazon'
      } end

      it { should contain_package('java-1.6.0-openjdk') }

    end

    context "On an unknown OS" do

      let :facts do {
        :operatingsystem => 'Darwin'
      } end

      it { expect { should raise_error(Puppet::Error) } }

    end

    context "Custom java package" do

      let :facts do {
        :operatingsystem => 'CentOS'
      } end

      let :params do {
        :java_install => true,
        :java_package => 'java-1.7.0-openjdk'
      } end

      it { should contain_package('java-1.7.0-openjdk') }

    end

  end

end

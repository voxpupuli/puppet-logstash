require 'spec_helper'

describe 'logstash', :type => 'class' do

  context "With a package" do

    ['Debian', 'Ubuntu', 'CentOS', 'Redhat', 'Fedora', 'Scientific', 'Amazon'].each do |distro|
      context "On #{distro} OS" do

        let :facts do {
          :operatingsystem => distro
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
        it { should contain_file('/etc/logstash/agent/config') }
        it { should contain_service('logstash').with(:enable => false, :ensure => 'stopped') }

      end

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

      # init.pp
      it { should contain_class('logstash::package') }
      it { should contain_class('logstash::config') }
      it { should contain_class('logstash::service') }

      # package.pp
      it { should contain_package('logstash') }

      context "with multi-instance enabled" do

        let :params do {
          :initfiles => { 'agent' => 'puppet:///path/to/init' }
        } end

        # service.pp
        it { should contain_service('logstash-agent') }
        it { should contain_file('/etc/init.d/logstash-agent').with(
          :source => 'puppet:///path/to/init',
          :content => nil
        ) }
      end

      context "without multi-instance" do

        let :params do {
          :initfiles      => 'puppet:///path/to/init',
          :multi_instance => false
        } end

        # service.pp
        it { should contain_service('logstash') }
        it { should contain_file('/etc/init.d/logstash').with(
          :source => 'puppet:///path/to/init',
          :content => nil
        ) }

      end

    end

  end

  context "With custom jar file" do

    context "with multi-instance" do

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

    context "without multi-instance" do

      context "and built in init script" do

        let :facts do {
          :operatingsystem => 'CentOS'
        } end

        let :params do {
          :provider => 'custom',
          :jarfile => "puppet:///path/to/logstash-1.1.9.jar",
          :installpath => '/opt/logstash',
          :multi_instance => false
        } end

        it { should_not contain_package('logstash') }
        it { should contain_file('/etc/init.d/logstash').with(:source => nil) }
        it { should contain_service('logstash') }

      end

      context "and custom init script" do

        let :facts do {
          :operatingsystem => 'CentOS'
        } end

        let :params do {
          :provider => 'custom',
          :jarfile => 'puppet:///path/to/logstash-1.1.9.jar',
          :installpath => '/opt/logstash',
          :initfiles => 'puppet:///path/to/logstash.init',
          :multi_instance => false
        } end

        it { should_not contain_package('logstash') }
        it { should contain_file('/etc/init.d/logstash').with(
          :source => 'puppet:///path/to/logstash.init')
        }
        it { should contain_service('logstash') }

      end

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

  context "test file owner option set to 'logstash'" do

    let :facts do {
      :operatingsystem => 'CentOS'
    } end

    let :params do {
      :logstash_user  => 'logstash',
      :logstash_group => 'logstash'
    } end

    it { should contain_file('/etc/logstash/agent/config').with(:owner => 'logstash', :group => 'logstash') }
    it { should contain_file('/etc/logstash/agent/sincedb').with(:owner => 'logstash', :group => 'logstash') }
    it { should contain_file('/usr/share/logstash/tmp').with(:owner => 'logstash', :group => 'logstash') }

  end

  context "test with multi-instance disabled" do

    let :facts do {
      :operatingsystem => 'CentOS'
    } end

    let :params do {
      :multi_instance => false
    } end

    it { should contain_service('logstash') }
    it { should contain_file('/etc/logstash/conf.d') }
    it { should_not contain_service('logstash-agent') }
    it { should_not contain_file('/etc/logstash/agent/config') }

  end

  context "use a config file instead of defines" do
  
    let :facts do {
      :operatingsystem => 'CentOS'
    } end

    context "single instance" do

      let :params do {
        :multi_instance => false,
        :conffile => 'puppet:///path/to/config'
      } end

      it { should contain_file('/etc/logstash/conf.d/logstash.config').with(:source => 'puppet:///path/to/config') }

    end

    context "multi instance" do

      let :params do {
        :instances => [ 'agent', 'indexer' ],
        :conffile =>  { 'agent' => 'puppet:///path/to/config/agent', 'indexer' => 'puppet:///path/to/config/indexer' }
      } end

      it { should contain_file('/etc/logstash/agent/config/logstash.config').with(:source => 'puppet:///path/to/config/agent') }
      it { should contain_file('/etc/logstash/indexer/config/logstash.config').with(:source => 'puppet:///path/to/config/indexer') }

    end

  end

  context "install java" do

    ['Debian', 'Ubuntu'].each do |distro|
      context "On #{distro} OS" do
        let :params do {
          :java_install => true
        } end

        let :facts do {
          :operatingsystem => distro
        } end

        it { should contain_package('openjdk-6-jre-headless') }

      end
    end

    ['CentOS', 'Redhat', 'Fedora', 'Scientific', 'Amazon'].each do |distro|
      context "On #{distro} OS" do
        let :params do {
          :java_install => true
        } end

        let :facts do {
          :operatingsystem => distro
        } end

        it { should contain_package('java-1.6.0-openjdk') }

      end
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

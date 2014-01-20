require 'spec_helper'

describe 'logstash', :type => 'class' do

  [ 'Debian', 'Ubuntu'].each do |distro|

    context "on #{distro} OS" do

      let :facts do {
        :operatingsystem => distro,
        :kernel => 'Linux'
      } end

      context 'main class tests' do

        # init.pp
        it { should contain_class('logstash::package') }
        it { should contain_class('logstash::config') }
        it { should contain_class('logstash::service') }

        it { should contain_file('/etc/logstash') }
        it { should contain_file('/etc/logstash/patterns') }
        it { should contain_file('/etc/logstash/plugins') }

      end

      context 'package installation' do
        
        context 'via repository' do

          context 'with default settings' do
            
           it { should contain_package('logstash').with(:ensure => 'present') }

          end

          context 'with specified version' do

            let :params do {
              :version => '1.0'
            } end

            it { should contain_package('logstash').with(:ensure => '1.0') }
          end

          context 'with auto upgrade enabled' do

            let :params do {
              :autoupgrade => true
            } end

            it { should contain_package('logstash').with(:ensure => 'latest') }
          end

        end

        context 'via software_url setting' do

          context 'using puppet:/// schema' do

            let :params do {
              :software_url => 'puppet:///path/to/package.deb'
            } end

            it { should contain_file('/opt/logstash/swdl/package.deb').with(:source => 'puppet:///path/to/package.deb', :backup => false) }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/opt/logstash/swdl/package.deb', :provider => 'dpkg') }
          end

          context 'using http:// schema' do

            let :params do {
              :software_url => 'http://www.domain.com/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /opt/logstash/swdl') }
            it { should contain_file('/opt/logstash/swdl').with(:purge => false, :force => false, :require => "Exec[create_software_dir]") }
            it { should contain_exec('download-package').with(:command => 'wget -O /opt/logstash/swdl/package.deb http://www.domain.com/path/to/package.deb 2> /dev/null', :require => 'File[/opt/logstash/swdl]') }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/opt/logstash/swdl/package.deb', :provider => 'dpkg') }
          end

          context 'using https:// schema' do

            let :params do {
              :software_url => 'https://www.domain.com/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /opt/logstash/swdl') }
            it { should contain_file('/opt/logstash/swdl').with(:purge => false, :force => false, :require => 'Exec[create_software_dir]') }
            it { should contain_exec('download-package').with(:command => 'wget -O /opt/logstash/swdl/package.deb https://www.domain.com/path/to/package.deb 2> /dev/null', :require => 'File[/opt/logstash/swdl]') }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/opt/logstash/swdl/package.deb', :provider => 'dpkg') }
          end

          context 'using ftp:// schema' do

            let :params do {
              :software_url => 'ftp://www.domain.com/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /opt/logstash/swdl') }
            it { should contain_file('/opt/logstash/swdl').with(:purge => false, :force => false, :require => 'Exec[create_software_dir]') }
            it { should contain_exec('download-package').with(:command => 'wget -O /opt/logstash/swdl/package.deb ftp://www.domain.com/path/to/package.deb 2> /dev/null', :require => 'File[/opt/logstash/swdl]') }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/opt/logstash/swdl/package.deb', :provider => 'dpkg') }
          end

          context 'using file:// schema' do

            let :params do {
              :software_url => 'file:/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /opt/logstash/swdl') }
            it { should contain_file('/opt/logstash/swdl').with(:purge => false, :force => false, :require => 'Exec[create_software_dir]') }
            it { should contain_file('/opt/logstash/swdl/package.deb').with(:source => '/path/to/package.deb', :backup => false) }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/opt/logstash/swdl/package.deb', :provider => 'dpkg') }
          end

        end

      end # package

      context 'service setup' do

        context 'with provider \'init\'' do

          context 'and default settings' do

            it { should contain_service('logstash').with(:ensure => 'running') }

          end

          context 'and set defaults via hash param' do

            let :params do {
              :init_defaults => { 'SERVICE_USER' => 'root', 'SERVICE_GROUP' => 'root' }
            } end

            it { should contain_file('/etc/default/logstash').with(:content => "### MANAGED BY PUPPET ###\n\nSERVICE_GROUP=root\nSERVICE_USER=root\n", :notify => 'Service[logstash]') }

          end

          context 'and set defaults via file param' do

            let :params do {
              :init_defaults_file => 'puppet:///path/to/logstash.defaults'
            } end

            it { should contain_file('/etc/default/logstash').with(:source => 'puppet:///path/to/logstash.defaults', :notify => 'Service[logstash]') }

          end

          context 'no service restart when defaults change' do

           let :params do {
              :init_defaults     => { 'SERVICE_USER' => 'root', 'SERVICE_GROUP' => 'root' },
              :restart_on_change => false
            } end

            it { should contain_file('/etc/default/logstash').with(:content => "### MANAGED BY PUPPET ###\n\nSERVICE_GROUP=root\nSERVICE_USER=root\n").without_notify }

          end

          context 'and set init file via template' do

            let :params do {
              :init_template => "logstash/etc/init.d/logstash.Debian.erb"
            } end

            it { should contain_file('/etc/init.d/logstash').with(:notify => 'Service[logstash]') }

          end

          context 'No service restart when restart_on_change is false' do

            let :params do {
              :init_template     => "logstash/etc/init.d/logstash.Debian.erb",
              :restart_on_change => false
            } end

            it { should contain_file('/etc/init.d/logstash').without_notify }

          end

          context 'when its unmanaged do nothing with it' do

            let :params do {
              :status => 'unmanaged'
            } end

            it { should contain_service('logstash').with(:ensure => nil, :enable => false) }

          end

        end # provider init

      end # Services

      context 'when setting the module to absent' do

         let :params do {
           :ensure => 'absent'
         } end

         it { should contain_file('/etc/logstash').with(:ensure => 'absent', :force => true, :recurse => true) }
         it { should contain_package('logstash').with(:ensure => 'purged') }
         it { should contain_service('logstash').with(:ensure => 'stopped', :enable => false) }

      end

    end

  end

end

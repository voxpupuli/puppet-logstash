require 'spec_helper'

describe 'logstash', :type => 'class' do

  [ 'Debian', 'Ubuntu'].each do |distro|

    context "on #{distro} OS" do

      let :facts do {
        :operatingsystem => distro
      } end

      context 'main class tests' do

        # init.pp
        it { should contain_class('logstash::package') }
        it { should contain_class('logstash::config') }
        it { should contain_class('logstash::service') }

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

            it { should contain_file('/var/lib/logstash/package.deb').with(:source => 'puppet:///path/to/package.deb', :backup => false) }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/var/lib/logstash/package.deb', :provider => 'dpkg') }
          end

          context 'using http:// schema' do

            let :params do {
              :software_url => 'http://www.domain.com/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /var/lib/logstash') }
            it { should contain_file('/var/lib/logstash').with(:purge => false, :force => false, :require => "Exec[create_software_dir]") }
            it { should contain_exec('download-package').with(:command => 'wget -O /var/lib/logstash/package.deb http://www.domain.com/path/to/package.deb 2> /dev/null', :require => 'File[/var/lib/logstash]') }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/var/lib/logstash/package.deb', :provider => 'dpkg') }
          end

          context 'using https:// schema' do

            let :params do {
              :software_url => 'https://www.domain.com/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /var/lib/logstash') }
            it { should contain_file('/var/lib/logstash').with(:purge => false, :force => false, :require => 'Exec[create_software_dir]') }
            it { should contain_exec('download-package').with(:command => 'wget -O /var/lib/logstash/package.deb https://www.domain.com/path/to/package.deb 2> /dev/null', :require => 'File[/var/lib/logstash]') }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/var/lib/logstash/package.deb', :provider => 'dpkg') }
          end

          context 'using ftp:// schema' do

            let :params do {
              :software_url => 'ftp://www.domain.com/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /var/lib/logstash') }
            it { should contain_file('/var/lib/logstash').with(:purge => false, :force => false, :require => 'Exec[create_software_dir]') }
            it { should contain_exec('download-package').with(:command => 'wget -O /var/lib/logstash/package.deb ftp://www.domain.com/path/to/package.deb 2> /dev/null', :require => 'File[/var/lib/logstash]') }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/var/lib/logstash/package.deb', :provider => 'dpkg') }
          end

          context 'using file:// schema' do

            let :params do {
              :software_url => 'file:/path/to/package.deb'
            } end

            it { should contain_exec('create_software_dir').with(:command => 'mkdir -p /var/lib/logstash') }
            it { should contain_file('/var/lib/logstash').with(:purge => false, :force => false, :require => 'Exec[create_software_dir]') }
            it { should contain_file('/var/lib/logstash/package.deb').with(:source => '/path/to/package.deb', :backup => false) }
            it { should contain_package('logstash').with(:ensure => 'present', :source => '/var/lib/logstash/package.deb', :provider => 'dpkg') }
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

            it { should contain_file('/etc/default/logstash').with(:content => "### MANAGED BY PUPPET ###\n\nSERVICE_GROUP=root\nSERVICE_USER=root\n") }

          end

          context 'and set defaults via file param' do

            let :params do {
              :init_defaults_file => 'puppet:///path/to/logstash.defaults'
            } end

            it { should contain_file('/etc/default/logstash').with(:source => 'puppet:///path/to/logstash.defaults') }

          end

          context 'and set init file via template' do

            let :params do {
              :init_template => '${module_name}/path/to/init.erb'
            } end

            it { should contain_file('/etc/init.d/logstash') }

          end

        end

      end # Services
    end

  end

end

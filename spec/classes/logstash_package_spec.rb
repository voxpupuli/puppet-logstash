require 'spec_helper'

describe 'logstash::package', :type => 'class' do

  ['Debian', 'Ubuntu', 'CentOS', 'Redhat', 'Fedora', 'Scientific', 'Amazon'].each do |distro|
    context "On #{distro} OS" do

      let(:facts) { { :operatingsystem => distro } }

      context 'provider => package' do

        context 'ensure => present' do

          context 'version => false' do

            context 'autoupgrade => false' do
              let(:pre_condition) { [
                "class logstash {
                  $ensure = 'present'
                  $version = false
                  $autoupgrade = false
                  $provider = 'package'
                }",
                "include logstash",
              ] }
              it { should contain_package('logstash').with_ensure('present') }
            end # autoupgrade false

            context 'autoupgrade => true' do
              let(:pre_condition) { [
                "class logstash {
                  $ensure = 'present'
                  $version = false
                  $autoupgrade = true
                  $provider = 'package'
                }",
                "include logstash",
              ] }
              it { should contain_package('logstash').with_ensure('latest') }
            end # autoupgrade false
          end # version false

          context 'version => 1.2.0' do
            let(:pre_condition) { [
              "class logstash {
                $ensure = 'present'
                $version = '1.2.0'
                $provider = 'package'
              }",
              "include logstash",
            ] }
            it { should contain_package('logstash').with_ensure('1.2.0') }
          end # version 1.2.0
        end # present

        context 'ensure => absent' do
          let(:pre_condition) { [
            "class logstash {
              $ensure = 'absent'
            }",
            "include logstash",
          ] }
          it { should contain_package('logstash').with_ensure('purged') }
        end # ensure absent
      end # using package


    end # distro

  end # distro each

end

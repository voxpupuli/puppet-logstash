require 'spec_helper'

describe 'logstash' do
  let :node do
    'agent.example.com'
  end
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts
      end
      context 'with all defaults' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('logstash') }
        it { is_expected.to contain_class('logstash::config') }
        it { is_expected.to contain_class('logstash::package') }
        it { is_expected.to contain_class('logstash::params') }
        it { is_expected.to contain_class('logstash::service') }
        it { is_expected.to contain_file('/etc/logstash/conf.d') }
        it { is_expected.to contain_file('/etc/logstash/jvm.options') }
        it { is_expected.to contain_file('/etc/logstash/logstash.yml') }
        it { is_expected.to contain_file('/etc/logstash/patterns') }
        it { is_expected.to contain_file('/etc/logstash/startup.options') }
        it { is_expected.to contain_file('/etc/logstash') }
        it { is_expected.to contain_service('logstash') }
        it { is_expected.to contain_package('logstash') }
      end
    end
  end
end

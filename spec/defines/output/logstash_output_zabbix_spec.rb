require 'spec_helper'

describe 'logstash::output::zabbix', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :port => 4,
      :tags => ['value5'],
      :type => 'value6',
      :zabbix_sender => 'puppet:///path/to/file7',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_zabbix_test').with(:content => "output {\n zabbix {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  host => \"value3\"\n  port => 4\n  tags => ['value5']\n  type => \"value6\"\n  zabbix_sender => \"/etc/logstash/files/output/zabbix/test/file7\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/output/zabbix/test/file7').with(:source => 'puppet:///path/to/file7') }
    it { should contain_file('/etc/logstash/files/output/zabbix/test') }
    it { should contain_exec('create_files_dir_output_zabbix_test').with(:command => 'mkdir -p /etc/logstash/files/output/zabbix/test') }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :port => 4,
      :tags => ['value5'],
      :type => 'value6',
      :zabbix_sender => 'puppet:///path/to/file7',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_zabbix_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_zabbix_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :port => 4,
      :tags => ['value5'],
      :type => 'value6',
      :zabbix_sender => 'puppet:///path/to/file7',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_zabbix_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

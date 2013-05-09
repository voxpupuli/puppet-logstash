require 'spec_helper'

describe 'logstash::filter::syslog_pri', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :facility_labels => ['value4'],
      :remove_tag => ['value5'],
      :severity_labels => ['value6'],
      :syslog_pri_field_name => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :use_labels => false,
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_syslog_pri_test').with(:content => "filter {\n syslog_pri {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  exclude_tags => ['value3']\n  facility_labels => ['value4']\n  remove_tag => ['value5']\n  severity_labels => ['value6']\n  syslog_pri_field_name => \"value7\"\n  tags => ['value8']\n  type => \"value9\"\n  use_labels => false\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :facility_labels => ['value4'],
      :remove_tag => ['value5'],
      :severity_labels => ['value6'],
      :syslog_pri_field_name => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :use_labels => false,
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_syslog_pri_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_syslog_pri_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :facility_labels => ['value4'],
      :remove_tag => ['value5'],
      :severity_labels => ['value6'],
      :syslog_pri_field_name => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :use_labels => false,
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_syslog_pri_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

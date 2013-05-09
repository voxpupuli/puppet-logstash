require 'spec_helper'

describe 'logstash::filter::kv', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :field_split => 'value4',
      :fields => ['value5'],
      :prefix => 'value6',
      :remove_tag => ['value7'],
      :source => 'value8',
      :tags => ['value9'],
      :target => 'value10',
      :trim => 'value11',
      :type => 'value12',
      :value_split => 'value13',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_kv_test').with(:content => "filter {\n kv {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  exclude_tags => ['value3']\n  field_split => \"value4\"\n  fields => ['value5']\n  prefix => \"value6\"\n  remove_tag => ['value7']\n  source => \"value8\"\n  tags => ['value9']\n  target => \"value10\"\n  trim => \"value11\"\n  type => \"value12\"\n  value_split => \"value13\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :field_split => 'value4',
      :fields => ['value5'],
      :prefix => 'value6',
      :remove_tag => ['value7'],
      :source => 'value8',
      :tags => ['value9'],
      :target => 'value10',
      :trim => 'value11',
      :type => 'value12',
      :value_split => 'value13',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_kv_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_kv_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :field_split => 'value4',
      :fields => ['value5'],
      :prefix => 'value6',
      :remove_tag => ['value7'],
      :source => 'value8',
      :tags => ['value9'],
      :target => 'value10',
      :trim => 'value11',
      :type => 'value12',
      :value_split => 'value13',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_kv_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

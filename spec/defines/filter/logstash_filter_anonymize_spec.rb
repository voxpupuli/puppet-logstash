require 'spec_helper'

describe 'logstash::filter::anonymize', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :algorithm => 'SHA1',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :key => 'value6',
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_anonymize_test').with(:content => "filter {\n anonymize {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  algorithm => \"SHA1\"\n  exclude_tags => ['value4']\n  fields => ['value5']\n  key => \"value6\"\n  remove_tag => ['value7']\n  tags => ['value8']\n  type => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :algorithm => 'SHA1',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :key => 'value6',
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_anonymize_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_anonymize_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :algorithm => 'SHA1',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :key => 'value6',
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_anonymize_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

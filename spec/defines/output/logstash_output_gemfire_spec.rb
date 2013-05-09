require 'spec_helper'

describe 'logstash::output::gemfire', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :cache_name => 'value1',
      :cache_xml_file => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :key_format => 'value5',
      :region_name => 'value6',
      :tags => ['value7'],
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_gemfire_test').with(:content => "output {\n gemfire {\n  cache_name => \"value1\"\n  cache_xml_file => \"value2\"\n  exclude_tags => ['value3']\n  fields => ['value4']\n  key_format => \"value5\"\n  region_name => \"value6\"\n  tags => ['value7']\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :cache_name => 'value1',
      :cache_xml_file => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :key_format => 'value5',
      :region_name => 'value6',
      :tags => ['value7'],
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_gemfire_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_gemfire_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :cache_name => 'value1',
      :cache_xml_file => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :key_format => 'value5',
      :region_name => 'value6',
      :tags => ['value7'],
      :type => 'value8',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_gemfire_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

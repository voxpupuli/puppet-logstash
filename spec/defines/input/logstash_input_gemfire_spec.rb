require 'spec_helper'

describe 'logstash::input::gemfire', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :cache_name => 'value2',
      :cache_xml_file => 'value3',
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :interest_regexp => 'value7',
      :message_format => 'value8',
      :query => 'value9',
      :region_name => 'value10',
      :serialization => 'value11',
      :tags => ['value12'],
      :threads => 13,
      :type => 'value14',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_gemfire_test').with(:content => "input {\n gemfire {\n  add_field => [\"field1\", \"value1\"]\n  cache_name => \"value2\"\n  cache_xml_file => \"value3\"\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  interest_regexp => \"value7\"\n  message_format => \"value8\"\n  query => \"value9\"\n  region_name => \"value10\"\n  serialization => \"value11\"\n  tags => ['value12']\n  threads => 13\n  type => \"value14\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :cache_name => 'value2',
      :cache_xml_file => 'value3',
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :interest_regexp => 'value7',
      :message_format => 'value8',
      :query => 'value9',
      :region_name => 'value10',
      :serialization => 'value11',
      :tags => ['value12'],
      :threads => 13,
      :type => 'value14',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_gemfire_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_gemfire_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :cache_name => 'value2',
      :cache_xml_file => 'value3',
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :interest_regexp => 'value7',
      :message_format => 'value8',
      :query => 'value9',
      :region_name => 'value10',
      :serialization => 'value11',
      :tags => ['value12'],
      :threads => 13,
      :type => 'value14',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_gemfire_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

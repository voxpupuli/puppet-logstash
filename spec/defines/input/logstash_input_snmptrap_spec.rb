require 'spec_helper'

describe 'logstash::input::snmptrap', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :community => 'value3',
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_snmptrap_test').with(:content => "input {\n snmptrap {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  community => \"value3\"\n  debug => false\n  format => \"plain\"\n  host => \"value6\"\n  message_format => \"value7\"\n  port => 8\n  tags => ['value9']\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :community => 'value3',
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_snmptrap_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_snmptrap_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :community => 'value3',
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_snmptrap_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

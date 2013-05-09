require 'spec_helper'

describe 'logstash::input::websocket', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value5',
      :mode => 'server',
      :tags => ['value7'],
      :type => 'value8',
      :url => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_websocket_test').with(:content => "input {\n websocket {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  message_format => \"value5\"\n  mode => \"server\"\n  tags => ['value7']\n  type => \"value8\"\n  url => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value5',
      :mode => 'server',
      :tags => ['value7'],
      :type => 'value8',
      :url => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_websocket_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_websocket_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value5',
      :mode => 'server',
      :tags => ['value7'],
      :type => 'value8',
      :url => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_websocket_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

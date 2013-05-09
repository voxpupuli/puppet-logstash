require 'spec_helper'

describe 'logstash::input::zeromq', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :address => ['value2'],
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value6',
      :mode => 'server',
      :sender => 'value8',
      :sockopt => { 'field9' => 'value9' },
      :tags => ['value10'],
      :topic => ['value11'],
      :topology => 'pushpull',
      :type => 'value13',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_zeromq_test').with(:content => "input {\n zeromq {\n  add_field => [\"field1\", \"value1\"]\n  address => ['value2']\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  message_format => \"value6\"\n  mode => \"server\"\n  sender => \"value8\"\n  sockopt => [\"field9\", \"value9\"]\n  tags => ['value10']\n  topic => ['value11']\n  topology => \"pushpull\"\n  type => \"value13\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :address => ['value2'],
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value6',
      :mode => 'server',
      :sender => 'value8',
      :sockopt => { 'field9' => 'value9' },
      :tags => ['value10'],
      :topic => ['value11'],
      :topology => 'pushpull',
      :type => 'value13',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_zeromq_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_zeromq_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :address => ['value2'],
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value6',
      :mode => 'server',
      :sender => 'value8',
      :sockopt => { 'field9' => 'value9' },
      :tags => ['value10'],
      :topic => ['value11'],
      :topology => 'pushpull',
      :type => 'value13',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_zeromq_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

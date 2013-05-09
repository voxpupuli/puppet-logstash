require 'spec_helper'

describe 'logstash::input::irc', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :channels => ['value2'],
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :nick => 'value8',
      :password => 'value9',
      :port => 10,
      :real => 'value11',
      :secure => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_irc_test').with(:content => "input {\n irc {\n  add_field => [\"field1\", \"value1\"]\n  channels => ['value2']\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  host => \"value6\"\n  message_format => \"value7\"\n  nick => \"value8\"\n  password => \"value9\"\n  port => 10\n  real => \"value11\"\n  secure => false\n  tags => ['value13']\n  type => \"value14\"\n  user => \"value15\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :channels => ['value2'],
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :nick => 'value8',
      :password => 'value9',
      :port => 10,
      :real => 'value11',
      :secure => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_irc_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_irc_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :channels => ['value2'],
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :nick => 'value8',
      :password => 'value9',
      :port => 10,
      :real => 'value11',
      :secure => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_irc_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

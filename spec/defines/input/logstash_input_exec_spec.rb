require 'spec_helper'

describe 'logstash::input::exec', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :command => 'value3',
      :debug => false,
      :format => 'plain',
      :interval => 6,
      :message_format => 'value7',
      :tags => ['value8'],
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_exec_test').with(:content => "input {\n exec {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  command => \"value3\"\n  debug => false\n  format => \"plain\"\n  interval => 6\n  message_format => \"value7\"\n  tags => ['value8']\n  type => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :command => 'value3',
      :debug => false,
      :format => 'plain',
      :interval => 6,
      :message_format => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_exec_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_exec_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :command => 'value3',
      :debug => false,
      :format => 'plain',
      :interval => 6,
      :message_format => 'value7',
      :tags => ['value8'],
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_exec_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

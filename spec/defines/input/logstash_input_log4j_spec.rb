require 'spec_helper'

describe 'logstash::input::log4j', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :data_timeout => 3,
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :mode => 'server',
      :port => 9,
      :tags => ['value10'],
      :type => 'value11',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_log4j_test').with(:content => "input {\n log4j {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  data_timeout => 3\n  debug => false\n  format => \"plain\"\n  host => \"value6\"\n  message_format => \"value7\"\n  mode => \"server\"\n  port => 9\n  tags => ['value10']\n  type => \"value11\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :data_timeout => 3,
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :mode => 'server',
      :port => 9,
      :tags => ['value10'],
      :type => 'value11',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_log4j_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_log4j_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :data_timeout => 3,
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :mode => 'server',
      :port => 9,
      :tags => ['value10'],
      :type => 'value11',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_log4j_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

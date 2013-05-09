require 'spec_helper'

describe 'logstash::output::tcp', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :message_format => 'value4',
      :mode => 'server',
      :port => 6,
      :tags => ['value7'],
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_tcp_test').with(:content => "output {\n tcp {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  host => \"value3\"\n  message_format => \"value4\"\n  mode => \"server\"\n  port => 6\n  tags => ['value7']\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :message_format => 'value4',
      :mode => 'server',
      :port => 6,
      :tags => ['value7'],
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_tcp_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_tcp_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :message_format => 'value4',
      :mode => 'server',
      :port => 6,
      :tags => ['value7'],
      :type => 'value8',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_tcp_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

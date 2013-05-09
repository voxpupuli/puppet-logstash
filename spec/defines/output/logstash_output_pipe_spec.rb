require 'spec_helper'

describe 'logstash::output::pipe', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :command => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :message_format => 'value4',
      :tags => ['value5'],
      :ttl => 6,
      :type => 'value7',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_pipe_test').with(:content => "output {\n pipe {\n  command => \"value1\"\n  exclude_tags => ['value2']\n  fields => ['value3']\n  message_format => \"value4\"\n  tags => ['value5']\n  ttl => 6\n  type => \"value7\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :command => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :message_format => 'value4',
      :tags => ['value5'],
      :ttl => 6,
      :type => 'value7',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_pipe_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_pipe_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :command => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :message_format => 'value4',
      :tags => ['value5'],
      :ttl => 6,
      :type => 'value7',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_pipe_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

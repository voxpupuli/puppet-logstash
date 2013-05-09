require 'spec_helper'

describe 'logstash::output::juggernaut', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :channels => ['value1'],
      :db => 2,
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :message_format => 'value6',
      :password => 'value7',
      :port => 8,
      :tags => ['value9'],
      :timeout => 10,
      :type => 'value11',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_juggernaut_test').with(:content => "output {\n juggernaut {\n  channels => ['value1']\n  db => 2\n  exclude_tags => ['value3']\n  fields => ['value4']\n  host => \"value5\"\n  message_format => \"value6\"\n  password => \"value7\"\n  port => 8\n  tags => ['value9']\n  timeout => 10\n  type => \"value11\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :channels => ['value1'],
      :db => 2,
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :message_format => 'value6',
      :password => 'value7',
      :port => 8,
      :tags => ['value9'],
      :timeout => 10,
      :type => 'value11',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_juggernaut_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_juggernaut_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :channels => ['value1'],
      :db => 2,
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :message_format => 'value6',
      :password => 'value7',
      :port => 8,
      :tags => ['value9'],
      :timeout => 10,
      :type => 'value11',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_juggernaut_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

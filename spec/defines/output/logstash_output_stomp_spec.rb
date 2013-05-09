require 'spec_helper'

describe 'logstash::output::stomp', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :debug => false,
      :destination => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :password => 'value6',
      :port => 7,
      :tags => ['value8'],
      :type => 'value9',
      :user => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_stomp_test').with(:content => "output {\n stomp {\n  debug => false\n  destination => \"value2\"\n  exclude_tags => ['value3']\n  fields => ['value4']\n  host => \"value5\"\n  password => \"value6\"\n  port => 7\n  tags => ['value8']\n  type => \"value9\"\n  user => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :destination => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :password => 'value6',
      :port => 7,
      :tags => ['value8'],
      :type => 'value9',
      :user => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_stomp_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_stomp_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :debug => false,
      :destination => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :password => 'value6',
      :port => 7,
      :tags => ['value8'],
      :type => 'value9',
      :user => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_stomp_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

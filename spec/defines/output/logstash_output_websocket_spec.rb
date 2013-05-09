require 'spec_helper'

describe 'logstash::output::websocket', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :port => 4,
      :tags => ['value5'],
      :type => 'value6',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_websocket_test').with(:content => "output {\n websocket {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  host => \"value3\"\n  port => 4\n  tags => ['value5']\n  type => \"value6\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :port => 4,
      :tags => ['value5'],
      :type => 'value6',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_websocket_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_websocket_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :port => 4,
      :tags => ['value5'],
      :type => 'value6',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_websocket_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

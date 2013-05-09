require 'spec_helper'

describe 'logstash::output::zeromq', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :address => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :mode => 'server',
      :sockopt => { 'field5' => 'value5' },
      :tags => ['value6'],
      :topic => 'value7',
      :topology => 'pushpull',
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_zeromq_test').with(:content => "output {\n zeromq {\n  address => ['value1']\n  exclude_tags => ['value2']\n  fields => ['value3']\n  mode => \"server\"\n  sockopt => [\"field5\", \"value5\"]\n  tags => ['value6']\n  topic => \"value7\"\n  topology => \"pushpull\"\n  type => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :address => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :mode => 'server',
      :sockopt => { 'field5' => 'value5' },
      :tags => ['value6'],
      :topic => 'value7',
      :topology => 'pushpull',
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_zeromq_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_zeromq_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :address => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :mode => 'server',
      :sockopt => { 'field5' => 'value5' },
      :tags => ['value6'],
      :topic => 'value7',
      :topology => 'pushpull',
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_zeromq_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

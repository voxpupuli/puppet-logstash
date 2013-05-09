require 'spec_helper'

describe 'logstash::filter::zeromq', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :address => 'value3',
      :exclude_tags => ['value4'],
      :field => 'value5',
      :mode => 'server',
      :remove_tag => ['value7'],
      :sockopt => { 'field8' => 'value8' },
      :tags => ['value9'],
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_zeromq_test').with(:content => "filter {\n zeromq {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  address => \"value3\"\n  exclude_tags => ['value4']\n  field => \"value5\"\n  mode => \"server\"\n  remove_tag => ['value7']\n  sockopt => [\"field8\", \"value8\"]\n  tags => ['value9']\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :address => 'value3',
      :exclude_tags => ['value4'],
      :field => 'value5',
      :mode => 'server',
      :remove_tag => ['value7'],
      :sockopt => { 'field8' => 'value8' },
      :tags => ['value9'],
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_zeromq_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_zeromq_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :address => 'value3',
      :exclude_tags => ['value4'],
      :field => 'value5',
      :mode => 'server',
      :remove_tag => ['value7'],
      :sockopt => { 'field8' => 'value8' },
      :tags => ['value9'],
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_zeromq_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

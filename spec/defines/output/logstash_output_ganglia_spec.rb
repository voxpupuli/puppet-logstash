require 'spec_helper'

describe 'logstash::output::ganglia', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :lifetime => 4,
      :max_interval => 5,
      :metric => 'value6',
      :metric_type => 'string',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
      :units => 'value11',
      :value => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_ganglia_test').with(:content => "output {\n ganglia {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  host => \"value3\"\n  lifetime => 4\n  max_interval => 5\n  metric => \"value6\"\n  metric_type => \"string\"\n  port => 8\n  tags => ['value9']\n  type => \"value10\"\n  units => \"value11\"\n  value => \"value12\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :lifetime => 4,
      :max_interval => 5,
      :metric => 'value6',
      :metric_type => 'string',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
      :units => 'value11',
      :value => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_ganglia_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_ganglia_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :lifetime => 4,
      :max_interval => 5,
      :metric => 'value6',
      :metric_type => 'string',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
      :units => 'value11',
      :value => 'value12',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_ganglia_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

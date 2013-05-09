require 'spec_helper'

describe 'logstash::output::mongodb', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :collection => 'value1',
      :database => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :isodate => false,
      :password => 'value7',
      :port => 8,
      :retry_delay => 9,
      :tags => ['value10'],
      :type => 'value11',
      :user => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_mongodb_test').with(:content => "output {\n mongodb {\n  collection => \"value1\"\n  database => \"value2\"\n  exclude_tags => ['value3']\n  fields => ['value4']\n  host => \"value5\"\n  isodate => false\n  password => \"value7\"\n  port => 8\n  retry_delay => 9\n  tags => ['value10']\n  type => \"value11\"\n  user => \"value12\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :collection => 'value1',
      :database => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :isodate => false,
      :password => 'value7',
      :port => 8,
      :retry_delay => 9,
      :tags => ['value10'],
      :type => 'value11',
      :user => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_mongodb_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_mongodb_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :collection => 'value1',
      :database => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :host => 'value5',
      :isodate => false,
      :password => 'value7',
      :port => 8,
      :retry_delay => 9,
      :tags => ['value10'],
      :type => 'value11',
      :user => 'value12',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_mongodb_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

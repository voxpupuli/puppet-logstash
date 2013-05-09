require 'spec_helper'

describe 'logstash::output::opentsdb', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :debug => false,
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :host => 'value4',
      :metrics => ['value5'],
      :port => 6,
      :tags => ['value7'],
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_opentsdb_test').with(:content => "output {\n opentsdb {\n  debug => false\n  exclude_tags => ['value2']\n  fields => ['value3']\n  host => \"value4\"\n  metrics => ['value5']\n  port => 6\n  tags => ['value7']\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :host => 'value4',
      :metrics => ['value5'],
      :port => 6,
      :tags => ['value7'],
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_opentsdb_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_opentsdb_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :debug => false,
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :host => 'value4',
      :metrics => ['value5'],
      :port => 6,
      :tags => ['value7'],
      :type => 'value8',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_opentsdb_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

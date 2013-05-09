require 'spec_helper'

describe 'logstash::output::statsd', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :count => { 'field1' => 'value1' },
      :debug => false,
      :decrement => ['value3'],
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :host => 'value6',
      :increment => ['value7'],
      :namespace => 'value8',
      :port => 9,
      :sample_rate => 10,
      :sender => 'value11',
      :tags => ['value12'],
      :timing => { 'field13' => 'value13' },
      :type => 'value14',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_statsd_test').with(:content => "output {\n statsd {\n  count => [\"field1\", \"value1\"]\n  debug => false\n  decrement => ['value3']\n  exclude_tags => ['value4']\n  fields => ['value5']\n  host => \"value6\"\n  increment => ['value7']\n  namespace => \"value8\"\n  port => 9\n  sample_rate => 10\n  sender => \"value11\"\n  tags => ['value12']\n  timing => [\"field13\", \"value13\"]\n  type => \"value14\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :count => { 'field1' => 'value1' },
      :debug => false,
      :decrement => ['value3'],
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :host => 'value6',
      :increment => ['value7'],
      :namespace => 'value8',
      :port => 9,
      :sample_rate => 10,
      :sender => 'value11',
      :tags => ['value12'],
      :timing => { 'field13' => 'value13' },
      :type => 'value14',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_statsd_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_statsd_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :count => { 'field1' => 'value1' },
      :debug => false,
      :decrement => ['value3'],
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :host => 'value6',
      :increment => ['value7'],
      :namespace => 'value8',
      :port => 9,
      :sample_rate => 10,
      :sender => 'value11',
      :tags => ['value12'],
      :timing => { 'field13' => 'value13' },
      :type => 'value14',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_statsd_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

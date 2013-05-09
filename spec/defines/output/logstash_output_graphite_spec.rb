require 'spec_helper'

describe 'logstash::output::graphite', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :debug => false,
      :exclude_metrics => ['value2'],
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :fields_are_metrics => false,
      :host => 'value6',
      :include_metrics => ['value7'],
      :metrics => { 'field8' => 'value8' },
      :metrics_format => 'value9',
      :port => 10,
      :reconnect_interval => 11,
      :resend_on_failure => false,
      :tags => ['value13'],
      :type => 'value14',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_graphite_test').with(:content => "output {\n graphite {\n  debug => false\n  exclude_metrics => ['value2']\n  exclude_tags => ['value3']\n  fields => ['value4']\n  fields_are_metrics => false\n  host => \"value6\"\n  include_metrics => ['value7']\n  metrics => [\"field8\", \"value8\"]\n  metrics_format => \"value9\"\n  port => 10\n  reconnect_interval => 11\n  resend_on_failure => false\n  tags => ['value13']\n  type => \"value14\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :exclude_metrics => ['value2'],
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :fields_are_metrics => false,
      :host => 'value6',
      :include_metrics => ['value7'],
      :metrics => { 'field8' => 'value8' },
      :metrics_format => 'value9',
      :port => 10,
      :reconnect_interval => 11,
      :resend_on_failure => false,
      :tags => ['value13'],
      :type => 'value14',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_graphite_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_graphite_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :debug => false,
      :exclude_metrics => ['value2'],
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :fields_are_metrics => false,
      :host => 'value6',
      :include_metrics => ['value7'],
      :metrics => { 'field8' => 'value8' },
      :metrics_format => 'value9',
      :port => 10,
      :reconnect_interval => 11,
      :resend_on_failure => false,
      :tags => ['value13'],
      :type => 'value14',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_graphite_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

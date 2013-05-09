require 'spec_helper'

describe 'logstash::output::graphtastic', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :batch_number => 1,
      :context => 'value2',
      :error_file => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :host => 'value6',
      :integration => 'udp',
      :metrics => { 'field8' => 'value8' },
      :port => 9,
      :retries => 10,
      :tags => ['value11'],
      :type => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_graphtastic_test').with(:content => "output {\n graphtastic {\n  batch_number => 1\n  context => \"value2\"\n  error_file => \"value3\"\n  exclude_tags => ['value4']\n  fields => ['value5']\n  host => \"value6\"\n  integration => \"udp\"\n  metrics => [\"field8\", \"value8\"]\n  port => 9\n  retries => 10\n  tags => ['value11']\n  type => \"value12\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :batch_number => 1,
      :context => 'value2',
      :error_file => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :host => 'value6',
      :integration => 'udp',
      :metrics => { 'field8' => 'value8' },
      :port => 9,
      :retries => 10,
      :tags => ['value11'],
      :type => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_graphtastic_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_graphtastic_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :batch_number => 1,
      :context => 'value2',
      :error_file => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :host => 'value6',
      :integration => 'udp',
      :metrics => { 'field8' => 'value8' },
      :port => 9,
      :retries => 10,
      :tags => ['value11'],
      :type => 'value12',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_graphtastic_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

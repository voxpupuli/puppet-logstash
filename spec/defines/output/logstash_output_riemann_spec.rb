require 'spec_helper'

describe 'logstash::output::riemann', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :debug => false,
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :host => 'value4',
      :port => 5,
      :protocol => 'tcp',
      :riemann_event => { 'field7' => 'value7' },
      :sender => 'value8',
      :tags => ['value9'],
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_riemann_test').with(:content => "output {\n riemann {\n  debug => false\n  exclude_tags => ['value2']\n  fields => ['value3']\n  host => \"value4\"\n  port => 5\n  protocol => \"tcp\"\n  riemann_event => [\"field7\", \"value7\"]\n  sender => \"value8\"\n  tags => ['value9']\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :host => 'value4',
      :port => 5,
      :protocol => 'tcp',
      :riemann_event => { 'field7' => 'value7' },
      :sender => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_riemann_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_riemann_test') }

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
      :port => 5,
      :protocol => 'tcp',
      :riemann_event => { 'field7' => 'value7' },
      :sender => 'value8',
      :tags => ['value9'],
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_riemann_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

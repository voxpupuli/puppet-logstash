require 'spec_helper'

describe 'logstash::input::syslog', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :facility_labels => ['value4'],
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :port => 8,
      :severity_labels => ['value9'],
      :tags => ['value10'],
      :type => 'value11',
      :use_labels => false,
    } end

    it { should contain_file('/etc/logstash/agent/config/input_syslog_test').with(:content => "input {\n syslog {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  facility_labels => ['value4']\n  format => \"plain\"\n  host => \"value6\"\n  message_format => \"value7\"\n  port => 8\n  severity_labels => ['value9']\n  tags => ['value10']\n  type => \"value11\"\n  use_labels => false\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :facility_labels => ['value4'],
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :port => 8,
      :severity_labels => ['value9'],
      :tags => ['value10'],
      :type => 'value11',
      :use_labels => false,
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_syslog_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_syslog_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :facility_labels => ['value4'],
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :port => 8,
      :severity_labels => ['value9'],
      :tags => ['value10'],
      :type => 'value11',
      :use_labels => false,
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_syslog_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

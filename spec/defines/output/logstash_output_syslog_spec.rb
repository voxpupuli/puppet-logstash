require 'spec_helper'

describe 'logstash::output::syslog', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :appname => 'value1',
      :exclude_tags => ['value2'],
      :facility => 'kernel',
      :fields => ['value4'],
      :host => 'value5',
      :msgid => 'value6',
      :port => 7,
      :procid => 'value8',
      :protocol => 'tcp',
      :rfc => 'rfc3164',
      :severity => 'emergency',
      :sourcehost => 'value12',
      :tags => ['value13'],
      :timestamp => 'value14',
      :type => 'value15',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_syslog_test').with(:content => "output {\n syslog {\n  appname => \"value1\"\n  exclude_tags => ['value2']\n  facility => \"kernel\"\n  fields => ['value4']\n  host => \"value5\"\n  msgid => \"value6\"\n  port => 7\n  procid => \"value8\"\n  protocol => \"tcp\"\n  rfc => \"rfc3164\"\n  severity => \"emergency\"\n  sourcehost => \"value12\"\n  tags => ['value13']\n  timestamp => \"value14\"\n  type => \"value15\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :appname => 'value1',
      :exclude_tags => ['value2'],
      :facility => 'kernel',
      :fields => ['value4'],
      :host => 'value5',
      :msgid => 'value6',
      :port => 7,
      :procid => 'value8',
      :protocol => 'tcp',
      :rfc => 'rfc3164',
      :severity => 'emergency',
      :sourcehost => 'value12',
      :tags => ['value13'],
      :timestamp => 'value14',
      :type => 'value15',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_syslog_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_syslog_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :appname => 'value1',
      :exclude_tags => ['value2'],
      :facility => 'kernel',
      :fields => ['value4'],
      :host => 'value5',
      :msgid => 'value6',
      :port => 7,
      :procid => 'value8',
      :protocol => 'tcp',
      :rfc => 'rfc3164',
      :severity => 'emergency',
      :sourcehost => 'value12',
      :tags => ['value13'],
      :timestamp => 'value14',
      :type => 'value15',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_syslog_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

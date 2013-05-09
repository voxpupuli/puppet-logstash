require 'spec_helper'

describe 'logstash::output::stdout', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :debug => false,
      :debug_format => 'ruby',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :message => 'value5',
      :tags => ['value6'],
      :type => 'value7',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_stdout_test').with(:content => "output {\n stdout {\n  debug => false\n  debug_format => \"ruby\"\n  exclude_tags => ['value3']\n  fields => ['value4']\n  message => \"value5\"\n  tags => ['value6']\n  type => \"value7\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :debug_format => 'ruby',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :message => 'value5',
      :tags => ['value6'],
      :type => 'value7',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_stdout_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_stdout_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :debug => false,
      :debug_format => 'ruby',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :message => 'value5',
      :tags => ['value6'],
      :type => 'value7',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_stdout_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

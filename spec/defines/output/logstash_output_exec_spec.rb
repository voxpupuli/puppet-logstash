require 'spec_helper'

describe 'logstash::output::exec', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :command => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :tags => ['value4'],
      :type => 'value5',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_exec_test').with(:content => "output {\n exec {\n  command => \"value1\"\n  exclude_tags => ['value2']\n  fields => ['value3']\n  tags => ['value4']\n  type => \"value5\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :command => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :tags => ['value4'],
      :type => 'value5',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_exec_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_exec_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :command => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :tags => ['value4'],
      :type => 'value5',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_exec_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

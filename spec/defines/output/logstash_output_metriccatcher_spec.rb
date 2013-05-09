require 'spec_helper'

describe 'logstash::output::metriccatcher', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :biased => { 'field1' => 'value1' },
      :counter => { 'field2' => 'value2' },
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :gauge => { 'field5' => 'value5' },
      :host => 'value6',
      :meter => { 'field7' => 'value7' },
      :port => 8,
      :tags => ['value9'],
      :timer => { 'field10' => 'value10' },
      :type => 'value11',
      :uniform => { 'field12' => 'value12' },
    } end

    it { should contain_file('/etc/logstash/agent/config/output_metriccatcher_test').with(:content => "output {\n metriccatcher {\n  biased => [\"field1\", \"value1\"]\n  counter => [\"field2\", \"value2\"]\n  exclude_tags => ['value3']\n  fields => ['value4']\n  gauge => [\"field5\", \"value5\"]\n  host => \"value6\"\n  meter => [\"field7\", \"value7\"]\n  port => 8\n  tags => ['value9']\n  timer => [\"field10\", \"value10\"]\n  type => \"value11\"\n  uniform => [\"field12\", \"value12\"]\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :biased => { 'field1' => 'value1' },
      :counter => { 'field2' => 'value2' },
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :gauge => { 'field5' => 'value5' },
      :host => 'value6',
      :meter => { 'field7' => 'value7' },
      :port => 8,
      :tags => ['value9'],
      :timer => { 'field10' => 'value10' },
      :type => 'value11',
      :uniform => { 'field12' => 'value12' },
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_metriccatcher_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_metriccatcher_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :biased => { 'field1' => 'value1' },
      :counter => { 'field2' => 'value2' },
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :gauge => { 'field5' => 'value5' },
      :host => 'value6',
      :meter => { 'field7' => 'value7' },
      :port => 8,
      :tags => ['value9'],
      :timer => { 'field10' => 'value10' },
      :type => 'value11',
      :uniform => { 'field12' => 'value12' },
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_metriccatcher_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

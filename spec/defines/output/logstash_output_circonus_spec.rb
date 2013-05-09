require 'spec_helper'

describe 'logstash::output::circonus', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :annotation => { 'field1' => 'value1' },
      :api_token => 'value2',
      :app_name => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :tags => ['value6'],
      :type => 'value7',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_circonus_test').with(:content => "output {\n circonus {\n  annotation => [\"field1\", \"value1\"]\n  api_token => \"value2\"\n  app_name => \"value3\"\n  exclude_tags => ['value4']\n  fields => ['value5']\n  tags => ['value6']\n  type => \"value7\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :annotation => { 'field1' => 'value1' },
      :api_token => 'value2',
      :app_name => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :tags => ['value6'],
      :type => 'value7',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_circonus_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_circonus_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :annotation => { 'field1' => 'value1' },
      :api_token => 'value2',
      :app_name => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :tags => ['value6'],
      :type => 'value7',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_circonus_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

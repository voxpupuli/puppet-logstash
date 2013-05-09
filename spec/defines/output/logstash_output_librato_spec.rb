require 'spec_helper'

describe 'logstash::output::librato', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :account_id => 'value1',
      :annotation => { 'field2' => 'value2' },
      :api_token => 'value3',
      :batch_size => 'value4',
      :counter => { 'field5' => 'value5' },
      :exclude_tags => ['value6'],
      :fields => ['value7'],
      :gauge => { 'field8' => 'value8' },
      :tags => ['value9'],
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_librato_test').with(:content => "output {\n librato {\n  account_id => \"value1\"\n  annotation => [\"field2\", \"value2\"]\n  api_token => \"value3\"\n  batch_size => \"value4\"\n  counter => [\"field5\", \"value5\"]\n  exclude_tags => ['value6']\n  fields => ['value7']\n  gauge => [\"field8\", \"value8\"]\n  tags => ['value9']\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :account_id => 'value1',
      :annotation => { 'field2' => 'value2' },
      :api_token => 'value3',
      :batch_size => 'value4',
      :counter => { 'field5' => 'value5' },
      :exclude_tags => ['value6'],
      :fields => ['value7'],
      :gauge => { 'field8' => 'value8' },
      :tags => ['value9'],
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_librato_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_librato_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :account_id => 'value1',
      :annotation => { 'field2' => 'value2' },
      :api_token => 'value3',
      :batch_size => 'value4',
      :counter => { 'field5' => 'value5' },
      :exclude_tags => ['value6'],
      :fields => ['value7'],
      :gauge => { 'field8' => 'value8' },
      :tags => ['value9'],
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_librato_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

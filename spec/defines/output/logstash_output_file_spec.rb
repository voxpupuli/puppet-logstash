require 'spec_helper'

describe 'logstash::output::file', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :flush_interval => 3,
      :gzip => false,
      :max_size => 'value5',
      :message_format => 'value6',
      :path => 'value7',
      :tags => ['value8'],
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_file_test').with(:content => "output {\n file {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  flush_interval => 3\n  gzip => false\n  max_size => \"value5\"\n  message_format => \"value6\"\n  path => \"value7\"\n  tags => ['value8']\n  type => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :flush_interval => 3,
      :gzip => false,
      :max_size => 'value5',
      :message_format => 'value6',
      :path => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_file_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_file_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :flush_interval => 3,
      :gzip => false,
      :max_size => 'value5',
      :message_format => 'value6',
      :path => 'value7',
      :tags => ['value8'],
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_file_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

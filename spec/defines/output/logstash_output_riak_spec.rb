require 'spec_helper'

describe 'logstash::output::riak', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :bucket => ['value1'],
      :bucket_props => { 'field2' => 'value2' },
      :enable_search => false,
      :enable_ssl => false,
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :indices => ['value7'],
      :key_name => 'value8',
      :nodes => { 'field9' => 'value9' },
      :proto => 'http',
      :ssl_opts => { 'field11' => 'value11' },
      :tags => ['value12'],
      :type => 'value13',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_riak_test').with(:content => "output {\n riak {\n  bucket => ['value1']\n  bucket_props => [\"field2\", \"value2\"]\n  enable_search => false\n  enable_ssl => false\n  exclude_tags => ['value5']\n  fields => ['value6']\n  indices => ['value7']\n  key_name => \"value8\"\n  nodes => [\"field9\", \"value9\"]\n  proto => \"http\"\n  ssl_opts => [\"field11\", \"value11\"]\n  tags => ['value12']\n  type => \"value13\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :bucket => ['value1'],
      :bucket_props => { 'field2' => 'value2' },
      :enable_search => false,
      :enable_ssl => false,
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :indices => ['value7'],
      :key_name => 'value8',
      :nodes => { 'field9' => 'value9' },
      :proto => 'http',
      :ssl_opts => { 'field11' => 'value11' },
      :tags => ['value12'],
      :type => 'value13',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_riak_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_riak_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :bucket => ['value1'],
      :bucket_props => { 'field2' => 'value2' },
      :enable_search => false,
      :enable_ssl => false,
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :indices => ['value7'],
      :key_name => 'value8',
      :nodes => { 'field9' => 'value9' },
      :proto => 'http',
      :ssl_opts => { 'field11' => 'value11' },
      :tags => ['value12'],
      :type => 'value13',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_riak_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

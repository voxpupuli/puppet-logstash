require 'spec_helper'

describe 'logstash::output::elasticsearch', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :bind_host => 'value1',
      :cluster => 'value2',
      :document_id => 'value3',
      :embedded => false,
      :embedded_http_port => 'value5',
      :exclude_tags => ['value6'],
      :fields => ['value7'],
      :host => 'value8',
      :index => 'value9',
      :index_type => 'value10',
      :max_inflight_requests => 11,
      :node_name => 'value12',
      :port => 13,
      :tags => ['value14'],
      :type => 'value15',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_elasticsearch_test').with(:content => "output {\n elasticsearch {\n  bind_host => \"value1\"\n  cluster => \"value2\"\n  document_id => \"value3\"\n  embedded => false\n  embedded_http_port => \"value5\"\n  exclude_tags => ['value6']\n  fields => ['value7']\n  host => \"value8\"\n  index => \"value9\"\n  index_type => \"value10\"\n  max_inflight_requests => 11\n  node_name => \"value12\"\n  port => 13\n  tags => ['value14']\n  type => \"value15\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :bind_host => 'value1',
      :cluster => 'value2',
      :document_id => 'value3',
      :embedded => false,
      :embedded_http_port => 'value5',
      :exclude_tags => ['value6'],
      :fields => ['value7'],
      :host => 'value8',
      :index => 'value9',
      :index_type => 'value10',
      :max_inflight_requests => 11,
      :node_name => 'value12',
      :port => 13,
      :tags => ['value14'],
      :type => 'value15',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_elasticsearch_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_elasticsearch_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :bind_host => 'value1',
      :cluster => 'value2',
      :document_id => 'value3',
      :embedded => false,
      :embedded_http_port => 'value5',
      :exclude_tags => ['value6'],
      :fields => ['value7'],
      :host => 'value8',
      :index => 'value9',
      :index_type => 'value10',
      :max_inflight_requests => 11,
      :node_name => 'value12',
      :port => 13,
      :tags => ['value14'],
      :type => 'value15',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_elasticsearch_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

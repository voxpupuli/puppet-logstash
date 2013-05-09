require 'spec_helper'

describe 'logstash::output::elasticsearch_http', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :document_id => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :flush_size => 4,
      :host => 'value5',
      :index => 'value6',
      :index_type => 'value7',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_elasticsearch_http_test').with(:content => "output {\n elasticsearch_http {\n  document_id => \"value1\"\n  exclude_tags => ['value2']\n  fields => ['value3']\n  flush_size => 4\n  host => \"value5\"\n  index => \"value6\"\n  index_type => \"value7\"\n  port => 8\n  tags => ['value9']\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :document_id => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :flush_size => 4,
      :host => 'value5',
      :index => 'value6',
      :index_type => 'value7',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_elasticsearch_http_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_elasticsearch_http_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :document_id => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :flush_size => 4,
      :host => 'value5',
      :index => 'value6',
      :index_type => 'value7',
      :port => 8,
      :tags => ['value9'],
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_elasticsearch_http_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

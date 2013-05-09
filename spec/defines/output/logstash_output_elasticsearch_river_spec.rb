require 'spec_helper'

describe 'logstash::output::elasticsearch_river', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :debug => false,
      :document_id => 'value2',
      :durable => false,
      :es_bulk_size => 4,
      :es_bulk_timeout_ms => 5,
      :es_host => 'value6',
      :es_ordered => false,
      :es_port => 8,
      :exchange => 'value9',
      :exchange_type => 'fanout',
      :exclude_tags => ['value11'],
      :fields => ['value12'],
      :index => 'value13',
      :index_type => 'value14',
      :key => 'value15',
      :password => 'value16',
      :persistent => false,
      :queue => 'value18',
      :rabbitmq_host => 'value19',
      :rabbitmq_port => 20,
      :tags => ['value21'],
      :type => 'value22',
      :user => 'value23',
      :vhost => 'value24',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_elasticsearch_river_test').with(:content => "output {\n elasticsearch_river {\n  debug => false\n  document_id => \"value2\"\n  durable => false\n  es_bulk_size => 4\n  es_bulk_timeout_ms => 5\n  es_host => \"value6\"\n  es_ordered => false\n  es_port => 8\n  exchange => \"value9\"\n  exchange_type => \"fanout\"\n  exclude_tags => ['value11']\n  fields => ['value12']\n  index => \"value13\"\n  index_type => \"value14\"\n  key => \"value15\"\n  password => \"value16\"\n  persistent => false\n  queue => \"value18\"\n  rabbitmq_host => \"value19\"\n  rabbitmq_port => 20\n  tags => ['value21']\n  type => \"value22\"\n  user => \"value23\"\n  vhost => \"value24\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :document_id => 'value2',
      :durable => false,
      :es_bulk_size => 4,
      :es_bulk_timeout_ms => 5,
      :es_host => 'value6',
      :es_ordered => false,
      :es_port => 8,
      :exchange => 'value9',
      :exchange_type => 'fanout',
      :exclude_tags => ['value11'],
      :fields => ['value12'],
      :index => 'value13',
      :index_type => 'value14',
      :key => 'value15',
      :password => 'value16',
      :persistent => false,
      :queue => 'value18',
      :rabbitmq_host => 'value19',
      :rabbitmq_port => 20,
      :tags => ['value21'],
      :type => 'value22',
      :user => 'value23',
      :vhost => 'value24',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_elasticsearch_river_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_elasticsearch_river_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :debug => false,
      :document_id => 'value2',
      :durable => false,
      :es_bulk_size => 4,
      :es_bulk_timeout_ms => 5,
      :es_host => 'value6',
      :es_ordered => false,
      :es_port => 8,
      :exchange => 'value9',
      :exchange_type => 'fanout',
      :exclude_tags => ['value11'],
      :fields => ['value12'],
      :index => 'value13',
      :index_type => 'value14',
      :key => 'value15',
      :password => 'value16',
      :persistent => false,
      :queue => 'value18',
      :rabbitmq_host => 'value19',
      :rabbitmq_port => 20,
      :tags => ['value21'],
      :type => 'value22',
      :user => 'value23',
      :vhost => 'value24',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_elasticsearch_river_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

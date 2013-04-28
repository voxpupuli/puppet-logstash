require 'spec_helper'

describe 'logstash::output::amqp', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :debug => false,
      :durable => false,
      :exchange => 'value3',
      :exchange_type => 'fanout',
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :fields_headers => ['value7'],
      :frame_max => 8,
      :host => 'value9',
      :key => 'value10',
      :password => 'value11',
      :persistent => false,
      :port => 13,
      :ssl => false,
      :tags => ['value15'],
      :type => 'value16',
      :user => 'value17',
      :verify_ssl => false,
      :vhost => 'value19',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_amqp_test').with(:content => "output {\n amqp {\n  debug => false\n  durable => false\n  exchange => \"value3\"\n  exchange_type => \"fanout\"\n  exclude_tags => ['value5']\n  fields => ['value6']\n  fields_headers => ['value7']\n  frame_max => 8\n  host => \"value9\"\n  key => \"value10\"\n  password => \"value11\"\n  persistent => false\n  port => 13\n  ssl => false\n  tags => ['value15']\n  type => \"value16\"\n  user => \"value17\"\n  verify_ssl => false\n  vhost => \"value19\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :durable => false,
      :exchange => 'value3',
      :exchange_type => 'fanout',
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :fields_headers => ['value7'],
      :frame_max => 8,
      :host => 'value9',
      :key => 'value10',
      :password => 'value11',
      :persistent => false,
      :port => 13,
      :ssl => false,
      :tags => ['value15'],
      :type => 'value16',
      :user => 'value17',
      :verify_ssl => false,
      :vhost => 'value19',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_amqp_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_amqp_test') }

  end

end

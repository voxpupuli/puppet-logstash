require 'spec_helper'

describe 'logstash::output::rabbitmq', :type => 'define' do

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
      :host => 'value7',
      :key => 'value8',
      :password => 'value9',
      :persistent => false,
      :port => 11,
      :ssl => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
      :verify_ssl => false,
      :vhost => 'value17',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_rabbitmq_test').with(:content => "output {\n rabbitmq {\n  debug => false\n  durable => false\n  exchange => \"value3\"\n  exchange_type => \"fanout\"\n  exclude_tags => ['value5']\n  fields => ['value6']\n  host => \"value7\"\n  key => \"value8\"\n  password => \"value9\"\n  persistent => false\n  port => 11\n  ssl => false\n  tags => ['value13']\n  type => \"value14\"\n  user => \"value15\"\n  verify_ssl => false\n  vhost => \"value17\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :debug => false,
      :durable => false,
      :exchange => 'value3',
      :exchange_type => 'fanout',
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :host => 'value7',
      :key => 'value8',
      :password => 'value9',
      :persistent => false,
      :port => 11,
      :ssl => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
      :verify_ssl => false,
      :vhost => 'value17',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_rabbitmq_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_rabbitmq_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :debug => false,
      :durable => false,
      :exchange => 'value3',
      :exchange_type => 'fanout',
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :host => 'value7',
      :key => 'value8',
      :password => 'value9',
      :persistent => false,
      :port => 11,
      :ssl => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
      :verify_ssl => false,
      :vhost => 'value17',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_rabbitmq_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

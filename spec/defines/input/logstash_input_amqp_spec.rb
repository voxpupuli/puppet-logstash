require 'spec_helper'

describe 'logstash::input::amqp', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :ack => false,
      :add_field => { 'field2' => 'value2' },
      :arguments => ['value3'],
      :auto_delete => false,
      :charset => 'ASCII-8BIT',
      :debug => false,
      :durable => false,
      :exchange => 'value8',
      :exclusive => false,
      :format => 'plain',
      :host => 'value11',
      :key => 'value12',
      :message_format => 'value13',
      :passive => false,
      :password => 'value15',
      :port => 16,
      :prefetch_count => 17,
      :queue => 'value18',
      :ssl => false,
      :tags => ['value20'],
      :threads => 21,
      :type => 'value22',
      :user => 'value23',
      :verify_ssl => false,
      :vhost => 'value25',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_amqp_test').with(:content => "input {\n amqp {\n  ack => false\n  add_field => [\"field2\", \"value2\"]\n  arguments => ['value3']\n  auto_delete => false\n  charset => \"ASCII-8BIT\"\n  debug => false\n  durable => false\n  exchange => \"value8\"\n  exclusive => false\n  format => \"plain\"\n  host => \"value11\"\n  key => \"value12\"\n  message_format => \"value13\"\n  passive => false\n  password => \"value15\"\n  port => 16\n  prefetch_count => 17\n  queue => \"value18\"\n  ssl => false\n  tags => ['value20']\n  threads => 21\n  type => \"value22\"\n  user => \"value23\"\n  verify_ssl => false\n  vhost => \"value25\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :ack => false,
      :add_field => { 'field2' => 'value2' },
      :arguments => ['value3'],
      :auto_delete => false,
      :charset => 'ASCII-8BIT',
      :debug => false,
      :durable => false,
      :exchange => 'value8',
      :exclusive => false,
      :format => 'plain',
      :host => 'value11',
      :key => 'value12',
      :message_format => 'value13',
      :passive => false,
      :password => 'value15',
      :port => 16,
      :prefetch_count => 17,
      :queue => 'value18',
      :ssl => false,
      :tags => ['value20'],
      :threads => 21,
      :type => 'value22',
      :user => 'value23',
      :verify_ssl => false,
      :vhost => 'value25',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_amqp_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_amqp_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :ack => false,
      :add_field => { 'field2' => 'value2' },
      :arguments => ['value3'],
      :auto_delete => false,
      :charset => 'ASCII-8BIT',
      :debug => false,
      :durable => false,
      :exchange => 'value8',
      :exclusive => false,
      :format => 'plain',
      :host => 'value11',
      :key => 'value12',
      :message_format => 'value13',
      :passive => false,
      :password => 'value15',
      :port => 16,
      :prefetch_count => 17,
      :queue => 'value18',
      :ssl => false,
      :tags => ['value20'],
      :threads => 21,
      :type => 'value22',
      :user => 'value23',
      :verify_ssl => false,
      :vhost => 'value25',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_amqp_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

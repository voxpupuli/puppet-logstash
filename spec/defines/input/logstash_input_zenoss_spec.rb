require 'spec_helper'

describe 'logstash::input::zenoss', :type => 'define' do

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
      :frame_max => 11,
      :headers_fields => ['value12'],
      :host => 'value13',
      :key => 'value14',
      :message_format => 'value15',
      :passive => false,
      :password => 'value17',
      :port => 18,
      :prefetch_count => 19,
      :queue => 'value20',
      :ssl => false,
      :tags => ['value22'],
      :threads => 23,
      :type => 'value24',
      :user => 'value25',
      :verify_ssl => false,
      :vhost => 'value27',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_zenoss_test').with(:content => "input {\n zenoss {\n  ack => false\n  add_field => [\"field2\", \"value2\"]\n  arguments => ['value3']\n  auto_delete => false\n  charset => \"ASCII-8BIT\"\n  debug => false\n  durable => false\n  exchange => \"value8\"\n  exclusive => false\n  format => \"plain\"\n  frame_max => 11\n  headers_fields => ['value12']\n  host => \"value13\"\n  key => \"value14\"\n  message_format => \"value15\"\n  passive => false\n  password => \"value17\"\n  port => 18\n  prefetch_count => 19\n  queue => \"value20\"\n  ssl => false\n  tags => ['value22']\n  threads => 23\n  type => \"value24\"\n  user => \"value25\"\n  verify_ssl => false\n  vhost => \"value27\"\n }\n}\n") }
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
      :frame_max => 11,
      :headers_fields => ['value12'],
      :host => 'value13',
      :key => 'value14',
      :message_format => 'value15',
      :passive => false,
      :password => 'value17',
      :port => 18,
      :prefetch_count => 19,
      :queue => 'value20',
      :ssl => false,
      :tags => ['value22'],
      :threads => 23,
      :type => 'value24',
      :user => 'value25',
      :verify_ssl => false,
      :vhost => 'value27',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_zenoss_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_zenoss_test') }

  end

end

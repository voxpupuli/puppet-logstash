require 'spec_helper'

describe 'logstash::input::redis', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :batch_count => 2,
      :charset => 'ASCII-8BIT',
      :data_type => 'list',
      :db => 5,
      :debug => false,
      :format => 'plain',
      :host => 'value8',
      :key => 'value9',
      :message_format => 'value10',
      :password => 'value11',
      :port => 12,
      :tags => ['value13'],
      :threads => 14,
      :timeout => 15,
      :type => 'value16',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_redis_test').with(:content => "input {\n redis {\n  add_field => [\"field1\", \"value1\"]\n  batch_count => 2\n  charset => \"ASCII-8BIT\"\n  data_type => \"list\"\n  db => 5\n  debug => false\n  format => \"plain\"\n  host => \"value8\"\n  key => \"value9\"\n  message_format => \"value10\"\n  password => \"value11\"\n  port => 12\n  tags => ['value13']\n  threads => 14\n  timeout => 15\n  type => \"value16\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :batch_count => 2,
      :charset => 'ASCII-8BIT',
      :data_type => 'list',
      :db => 5,
      :debug => false,
      :format => 'plain',
      :host => 'value8',
      :key => 'value9',
      :message_format => 'value10',
      :password => 'value11',
      :port => 12,
      :tags => ['value13'],
      :threads => 14,
      :timeout => 15,
      :type => 'value16',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_redis_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_redis_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :batch_count => 2,
      :charset => 'ASCII-8BIT',
      :data_type => 'list',
      :db => 5,
      :debug => false,
      :format => 'plain',
      :host => 'value8',
      :key => 'value9',
      :message_format => 'value10',
      :password => 'value11',
      :port => 12,
      :tags => ['value13'],
      :threads => 14,
      :timeout => 15,
      :type => 'value16',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_redis_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

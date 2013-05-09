require 'spec_helper'

describe 'logstash::input::elasticsearch', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :index => 'value6',
      :message_format => 'value7',
      :port => 8,
      :query => 'value9',
      :tags => ['value10'],
      :type => 'value11',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_elasticsearch_test').with(:content => "input {\n elasticsearch {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  host => \"value5\"\n  index => \"value6\"\n  message_format => \"value7\"\n  port => 8\n  query => \"value9\"\n  tags => ['value10']\n  type => \"value11\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :index => 'value6',
      :message_format => 'value7',
      :port => 8,
      :query => 'value9',
      :tags => ['value10'],
      :type => 'value11',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_elasticsearch_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_elasticsearch_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :index => 'value6',
      :message_format => 'value7',
      :port => 8,
      :query => 'value9',
      :tags => ['value10'],
      :type => 'value11',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_elasticsearch_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

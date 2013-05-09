require 'spec_helper'

describe 'logstash::input::sqs', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :access_key_id => 'value1',
      :add_field => { 'field2' => 'value2' },
      :aws_credentials_file => 'value3',
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value7',
      :queue => 'value8',
      :region => 'us-east-1',
      :secret_access_key => 'value10',
      :tags => ['value11'],
      :threads => 12,
      :type => 'value13',
      :use_ssl => false,
    } end

    it { should contain_file('/etc/logstash/agent/config/input_sqs_test').with(:content => "input {\n sqs {\n  access_key_id => \"value1\"\n  add_field => [\"field2\", \"value2\"]\n  aws_credentials_file => \"value3\"\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  message_format => \"value7\"\n  queue => \"value8\"\n  region => \"us-east-1\"\n  secret_access_key => \"value10\"\n  tags => ['value11']\n  threads => 12\n  type => \"value13\"\n  use_ssl => false\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :access_key_id => 'value1',
      :add_field => { 'field2' => 'value2' },
      :aws_credentials_file => 'value3',
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value7',
      :queue => 'value8',
      :region => 'us-east-1',
      :secret_access_key => 'value10',
      :tags => ['value11'],
      :threads => 12,
      :type => 'value13',
      :use_ssl => false,
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_sqs_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_sqs_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :access_key_id => 'value1',
      :add_field => { 'field2' => 'value2' },
      :aws_credentials_file => 'value3',
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :message_format => 'value7',
      :queue => 'value8',
      :region => 'us-east-1',
      :secret_access_key => 'value10',
      :tags => ['value11'],
      :threads => 12,
      :type => 'value13',
      :use_ssl => false,
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_sqs_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

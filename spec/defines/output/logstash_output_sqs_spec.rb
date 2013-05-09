require 'spec_helper'

describe 'logstash::output::sqs', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :access_key_id => 'value1',
      :aws_credentials_file => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :queue => 'value5',
      :region => 'us-east-1',
      :secret_access_key => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :use_ssl => false,
    } end

    it { should contain_file('/etc/logstash/agent/config/output_sqs_test').with(:content => "output {\n sqs {\n  access_key_id => \"value1\"\n  aws_credentials_file => \"value2\"\n  exclude_tags => ['value3']\n  fields => ['value4']\n  queue => \"value5\"\n  region => \"us-east-1\"\n  secret_access_key => \"value7\"\n  tags => ['value8']\n  type => \"value9\"\n  use_ssl => false\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :access_key_id => 'value1',
      :aws_credentials_file => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :queue => 'value5',
      :region => 'us-east-1',
      :secret_access_key => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :use_ssl => false,
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_sqs_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_sqs_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :access_key_id => 'value1',
      :aws_credentials_file => 'value2',
      :exclude_tags => ['value3'],
      :fields => ['value4'],
      :queue => 'value5',
      :region => 'us-east-1',
      :secret_access_key => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :use_ssl => false,
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_sqs_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

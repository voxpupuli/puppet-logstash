require 'spec_helper'

describe 'logstash::output::sns', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :access_key_id => 'value1',
      :arn => 'value2',
      :aws_credentials_file => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :format => 'json',
      :publish_boot_message_arn => 'value7',
      :region => 'us-east-1',
      :secret_access_key => 'value9',
      :tags => ['value10'],
      :type => 'value11',
      :use_ssl => false,
    } end

    it { should contain_file('/etc/logstash/agent/config/output_sns_test').with(:content => "output {\n sns {\n  access_key_id => \"value1\"\n  arn => \"value2\"\n  aws_credentials_file => \"value3\"\n  exclude_tags => ['value4']\n  fields => ['value5']\n  format => \"json\"\n  publish_boot_message_arn => \"value7\"\n  region => \"us-east-1\"\n  secret_access_key => \"value9\"\n  tags => ['value10']\n  type => \"value11\"\n  use_ssl => false\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :access_key_id => 'value1',
      :arn => 'value2',
      :aws_credentials_file => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :format => 'json',
      :publish_boot_message_arn => 'value7',
      :region => 'us-east-1',
      :secret_access_key => 'value9',
      :tags => ['value10'],
      :type => 'value11',
      :use_ssl => false,
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_sns_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_sns_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :access_key_id => 'value1',
      :arn => 'value2',
      :aws_credentials_file => 'value3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :format => 'json',
      :publish_boot_message_arn => 'value7',
      :region => 'us-east-1',
      :secret_access_key => 'value9',
      :tags => ['value10'],
      :type => 'value11',
      :use_ssl => false,
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_sns_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

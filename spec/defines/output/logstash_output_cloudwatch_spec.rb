require 'spec_helper'

describe 'logstash::output::cloudwatch', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :access_key_id => 'value1',
      :aws_credentials_file => 'value2',
      :dimensions => { 'field3' => 'value3' },
      :exclude_tags => ['value4'],
      :field_dimensions => 'value5',
      :field_metricname => 'value6',
      :field_namespace => 'value7',
      :field_unit => 'value8',
      :field_value => 'value9',
      :fields => ['value10'],
      :metricname => 'value11',
      :namespace => 'value12',
      :queue_size => 13,
      :region => 'us-east-1',
      :secret_access_key => 'value15',
      :tags => ['value16'],
      :timeframe => 'value17',
      :type => 'value18',
      :unit => 'Seconds',
      :use_ssl => false,
      :value => 'value21',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_cloudwatch_test').with(:content => "output {\n cloudwatch {\n  access_key_id => \"value1\"\n  aws_credentials_file => \"value2\"\n  dimensions => [\"field3\", \"value3\"]\n  exclude_tags => ['value4']\n  field_dimensions => \"value5\"\n  field_metricname => \"value6\"\n  field_namespace => \"value7\"\n  field_unit => \"value8\"\n  field_value => \"value9\"\n  fields => ['value10']\n  metricname => \"value11\"\n  namespace => \"value12\"\n  queue_size => 13\n  region => \"us-east-1\"\n  secret_access_key => \"value15\"\n  tags => ['value16']\n  timeframe => \"value17\"\n  type => \"value18\"\n  unit => \"Seconds\"\n  use_ssl => false\n  value => \"value21\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :access_key_id => 'value1',
      :aws_credentials_file => 'value2',
      :dimensions => { 'field3' => 'value3' },
      :exclude_tags => ['value4'],
      :field_dimensions => 'value5',
      :field_metricname => 'value6',
      :field_namespace => 'value7',
      :field_unit => 'value8',
      :field_value => 'value9',
      :fields => ['value10'],
      :metricname => 'value11',
      :namespace => 'value12',
      :queue_size => 13,
      :region => 'us-east-1',
      :secret_access_key => 'value15',
      :tags => ['value16'],
      :timeframe => 'value17',
      :type => 'value18',
      :unit => 'Seconds',
      :use_ssl => false,
      :value => 'value21',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_cloudwatch_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_cloudwatch_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :access_key_id => 'value1',
      :aws_credentials_file => 'value2',
      :dimensions => { 'field3' => 'value3' },
      :exclude_tags => ['value4'],
      :field_dimensions => 'value5',
      :field_metricname => 'value6',
      :field_namespace => 'value7',
      :field_unit => 'value8',
      :field_value => 'value9',
      :fields => ['value10'],
      :metricname => 'value11',
      :namespace => 'value12',
      :queue_size => 13,
      :region => 'us-east-1',
      :secret_access_key => 'value15',
      :tags => ['value16'],
      :timeframe => 'value17',
      :type => 'value18',
      :unit => 'Seconds',
      :use_ssl => false,
      :value => 'value21',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_cloudwatch_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

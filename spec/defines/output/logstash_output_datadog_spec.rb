require 'spec_helper'

describe 'logstash::output::datadog', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :alert_type => 'info',
      :api_key => 'value2',
      :date_happened => 'value3',
      :dd_tags => ['value4'],
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :priority => 'normal',
      :source_type_name => 'nagios',
      :tags => ['value9'],
      :text => 'value10',
      :title => 'value11',
      :type => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_datadog_test').with(:content => "output {\n datadog {\n  alert_type => \"info\"\n  api_key => \"value2\"\n  date_happened => \"value3\"\n  dd_tags => ['value4']\n  exclude_tags => ['value5']\n  fields => ['value6']\n  priority => \"normal\"\n  source_type_name => \"nagios\"\n  tags => ['value9']\n  text => \"value10\"\n  title => \"value11\"\n  type => \"value12\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :alert_type => 'info',
      :api_key => 'value2',
      :date_happened => 'value3',
      :dd_tags => ['value4'],
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :priority => 'normal',
      :source_type_name => 'nagios',
      :tags => ['value9'],
      :text => 'value10',
      :title => 'value11',
      :type => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_datadog_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_datadog_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :alert_type => 'info',
      :api_key => 'value2',
      :date_happened => 'value3',
      :dd_tags => ['value4'],
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :priority => 'normal',
      :source_type_name => 'nagios',
      :tags => ['value9'],
      :text => 'value10',
      :title => 'value11',
      :type => 'value12',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_datadog_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

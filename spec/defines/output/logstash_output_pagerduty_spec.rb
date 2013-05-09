require 'spec_helper'

describe 'logstash::output::pagerduty', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :description => 'value1',
      :details => { 'field2' => 'value2' },
      :event_type => 'trigger',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :incident_key => 'value6',
      :pdurl => 'value7',
      :service_key => 'value8',
      :tags => ['value9'],
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_pagerduty_test').with(:content => "output {\n pagerduty {\n  description => \"value1\"\n  details => [\"field2\", \"value2\"]\n  event_type => \"trigger\"\n  exclude_tags => ['value4']\n  fields => ['value5']\n  incident_key => \"value6\"\n  pdurl => \"value7\"\n  service_key => \"value8\"\n  tags => ['value9']\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :description => 'value1',
      :details => { 'field2' => 'value2' },
      :event_type => 'trigger',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :incident_key => 'value6',
      :pdurl => 'value7',
      :service_key => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_pagerduty_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_pagerduty_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :description => 'value1',
      :details => { 'field2' => 'value2' },
      :event_type => 'trigger',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :incident_key => 'value6',
      :pdurl => 'value7',
      :service_key => 'value8',
      :tags => ['value9'],
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_pagerduty_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

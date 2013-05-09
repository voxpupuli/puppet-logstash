require 'spec_helper'

describe 'logstash::filter::json', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :remove_tag => ['value4'],
      :source => 'value5',
      :tags => ['value6'],
      :target => 'value7',
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_json_test').with(:content => "filter {\n json {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  exclude_tags => ['value3']\n  remove_tag => ['value4']\n  source => \"value5\"\n  tags => ['value6']\n  target => \"value7\"\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :remove_tag => ['value4'],
      :source => 'value5',
      :tags => ['value6'],
      :target => 'value7',
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_json_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_json_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :remove_tag => ['value4'],
      :source => 'value5',
      :tags => ['value6'],
      :target => 'value7',
      :type => 'value8',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_json_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

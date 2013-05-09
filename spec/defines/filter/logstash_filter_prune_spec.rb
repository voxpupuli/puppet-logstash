require 'spec_helper'

describe 'logstash::filter::prune', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :blacklist_names => ['value3'],
      :blacklist_values => { 'field4' => 'value4' },
      :exclude_tags => ['value5'],
      :interpolate => false,
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
      :whitelist_names => ['value10'],
      :whitelist_values => { 'field11' => 'value11' },
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_prune_test').with(:content => "filter {\n prune {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  blacklist_names => ['value3']\n  blacklist_values => [\"field4\", \"value4\"]\n  exclude_tags => ['value5']\n  interpolate => false\n  remove_tag => ['value7']\n  tags => ['value8']\n  type => \"value9\"\n  whitelist_names => ['value10']\n  whitelist_values => [\"field11\", \"value11\"]\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :blacklist_names => ['value3'],
      :blacklist_values => { 'field4' => 'value4' },
      :exclude_tags => ['value5'],
      :interpolate => false,
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
      :whitelist_names => ['value10'],
      :whitelist_values => { 'field11' => 'value11' },
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_prune_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_prune_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :blacklist_names => ['value3'],
      :blacklist_values => { 'field4' => 'value4' },
      :exclude_tags => ['value5'],
      :interpolate => false,
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
      :whitelist_names => ['value10'],
      :whitelist_values => { 'field11' => 'value11' },
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_prune_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

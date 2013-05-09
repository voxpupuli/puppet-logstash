require 'spec_helper'

describe 'logstash::filter::sleep', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :every => 'value3',
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :replay => false,
      :tags => ['value7'],
      :time => 'value8',
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_sleep_test').with(:content => "filter {\n sleep {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  every => \"value3\"\n  exclude_tags => ['value4']\n  remove_tag => ['value5']\n  replay => false\n  tags => ['value7']\n  time => \"value8\"\n  type => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :every => 'value3',
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :replay => false,
      :tags => ['value7'],
      :time => 'value8',
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_sleep_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_sleep_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :every => 'value3',
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :replay => false,
      :tags => ['value7'],
      :time => 'value8',
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_sleep_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

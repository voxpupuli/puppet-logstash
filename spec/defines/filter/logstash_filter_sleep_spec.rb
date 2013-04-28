require 'spec_helper'

describe 'logstash::filter::sleep', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :remove_tag => ['value4'],
      :replay => false,
      :tags => ['value6'],
      :time => 'value7',
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_sleep_test').with(:content => "filter {\n sleep {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  exclude_tags => ['value3']\n  remove_tag => ['value4']\n  replay => false\n  tags => ['value6']\n  time => \"value7\"\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :remove_tag => ['value4'],
      :replay => false,
      :tags => ['value6'],
      :time => 'value7',
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_sleep_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_sleep_test') }

  end

end

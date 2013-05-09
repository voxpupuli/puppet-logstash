require 'spec_helper'

describe 'logstash::filter::ruby', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :code => 'value3',
      :exclude_tags => ['value4'],
      :init => 'value5',
      :remove_tag => ['value6'],
      :tags => ['value7'],
      :type => 'value8',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_ruby_test').with(:content => "filter {\n ruby {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  code => \"value3\"\n  exclude_tags => ['value4']\n  init => \"value5\"\n  remove_tag => ['value6']\n  tags => ['value7']\n  type => \"value8\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :code => 'value3',
      :exclude_tags => ['value4'],
      :init => 'value5',
      :remove_tag => ['value6'],
      :tags => ['value7'],
      :type => 'value8',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_ruby_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_ruby_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :code => 'value3',
      :exclude_tags => ['value4'],
      :init => 'value5',
      :remove_tag => ['value6'],
      :tags => ['value7'],
      :type => 'value8',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_ruby_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

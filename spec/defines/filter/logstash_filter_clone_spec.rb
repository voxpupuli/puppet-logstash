require 'spec_helper'

describe 'logstash::filter::clone', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :clones => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :tags => ['value6'],
      :type => 'value7',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_clone_test').with(:content => "filter {\n clone {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  clones => ['value3']\n  exclude_tags => ['value4']\n  remove_tag => ['value5']\n  tags => ['value6']\n  type => \"value7\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :clones => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :tags => ['value6'],
      :type => 'value7',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_clone_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_clone_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :clones => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :tags => ['value6'],
      :type => 'value7',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_clone_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

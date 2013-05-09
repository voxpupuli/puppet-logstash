require 'spec_helper'

describe 'logstash::filter::grep', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :drop => false,
      :exclude_tags => ['value4'],
      :match => { 'field5' => 'value5' },
      :negate => false,
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_grep_test').with(:content => "filter {\n grep {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  drop => false\n  exclude_tags => ['value4']\n  match => [\"field5\", \"value5\"]\n  negate => false\n  remove_tag => ['value7']\n  tags => ['value8']\n  type => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :drop => false,
      :exclude_tags => ['value4'],
      :match => { 'field5' => 'value5' },
      :negate => false,
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_grep_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_grep_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :drop => false,
      :exclude_tags => ['value4'],
      :match => { 'field5' => 'value5' },
      :negate => false,
      :remove_tag => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_grep_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

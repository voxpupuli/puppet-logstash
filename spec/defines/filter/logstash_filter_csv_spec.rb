require 'spec_helper'

describe 'logstash::filter::csv', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :columns => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :separator => 'value6',
      :source => 'value7',
      :tags => ['value8'],
      :target => 'value9',
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_csv_test').with(:content => "filter {\n csv {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  columns => ['value3']\n  exclude_tags => ['value4']\n  remove_tag => ['value5']\n  separator => \"value6\"\n  source => \"value7\"\n  tags => ['value8']\n  target => \"value9\"\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :columns => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :separator => 'value6',
      :source => 'value7',
      :tags => ['value8'],
      :target => 'value9',
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_csv_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_csv_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :columns => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :separator => 'value6',
      :source => 'value7',
      :tags => ['value8'],
      :target => 'value9',
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_csv_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

require 'spec_helper'

describe 'logstash::filter::multiline', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :negate => false,
      :pattern => 'value5',
      :patterns_dir => ['value6'],
      :remove_tag => ['value7'],
      :stream_identity => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :what => 'previous',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_multiline_test').with(:content => "filter {\n multiline {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  exclude_tags => ['value3']\n  negate => false\n  pattern => \"value5\"\n  patterns_dir => ['value6']\n  remove_tag => ['value7']\n  stream_identity => \"value8\"\n  tags => ['value9']\n  type => \"value10\"\n  what => \"previous\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :negate => false,
      :pattern => 'value5',
      :patterns_dir => ['value6'],
      :remove_tag => ['value7'],
      :stream_identity => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :what => 'previous',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_multiline_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_multiline_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :exclude_tags => ['value3'],
      :negate => false,
      :pattern => 'value5',
      :patterns_dir => ['value6'],
      :remove_tag => ['value7'],
      :stream_identity => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :what => 'previous',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_multiline_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

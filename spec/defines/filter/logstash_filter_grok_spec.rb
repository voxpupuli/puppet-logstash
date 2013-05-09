require 'spec_helper'

describe 'logstash::filter::grok', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :break_on_match => false,
      :drop_if_match => false,
      :exclude_tags => ['value5'],
      :keep_empty_captures => false,
      :match => { 'field7' => 'value7' },
      :named_captures_only => false,
      :pattern => ['value9'],
      :patterns_dir => ['value10'],
      :remove_tag => ['value11'],
      :singles => false,
      :tag_on_failure => ['value13'],
      :tags => ['value14'],
      :type => 'value15',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_grok_test').with(:content => "filter {\n grok {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  break_on_match => false\n  drop_if_match => false\n  exclude_tags => ['value5']\n  keep_empty_captures => false\n  match => [\"field7\", \"value7\"]\n  named_captures_only => false\n  pattern => ['value9']\n  patterns_dir => ['value10']\n  remove_tag => ['value11']\n  singles => false\n  tag_on_failure => ['value13']\n  tags => ['value14']\n  type => \"value15\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :break_on_match => false,
      :drop_if_match => false,
      :exclude_tags => ['value5'],
      :keep_empty_captures => false,
      :match => { 'field7' => 'value7' },
      :named_captures_only => false,
      :pattern => ['value9'],
      :patterns_dir => ['value10'],
      :remove_tag => ['value11'],
      :singles => false,
      :tag_on_failure => ['value13'],
      :tags => ['value14'],
      :type => 'value15',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_grok_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_grok_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :break_on_match => false,
      :drop_if_match => false,
      :exclude_tags => ['value5'],
      :keep_empty_captures => false,
      :match => { 'field7' => 'value7' },
      :named_captures_only => false,
      :pattern => ['value9'],
      :patterns_dir => ['value10'],
      :remove_tag => ['value11'],
      :singles => false,
      :tag_on_failure => ['value13'],
      :tags => ['value14'],
      :type => 'value15',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_grok_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

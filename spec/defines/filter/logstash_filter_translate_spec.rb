require 'spec_helper'

describe 'logstash::filter::translate', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :destination => 'value3',
      :dictionary => { 'field4' => 'value4' },
      :dictionary_path => 'puppet:///path/to/file5',
      :exact => false,
      :exclude_tags => ['value7'],
      :fallback => 'value8',
      :field => 'value9',
      :override => false,
      :regex => false,
      :remove_tag => ['value12'],
      :tags => ['value13'],
      :type => 'value14',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_translate_test').with(:content => "filter {\n translate {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  destination => \"value3\"\n  dictionary => [\"field4\", \"value4\"]\n  dictionary_path => \"/etc/logstash/files/filter/translate/test/file5\"\n  exact => false\n  exclude_tags => ['value7']\n  fallback => \"value8\"\n  field => \"value9\"\n  override => false\n  regex => false\n  remove_tag => ['value12']\n  tags => ['value13']\n  type => \"value14\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/filter/translate/test/file5').with(:source => 'puppet:///path/to/file5') }
    it { should contain_file('/etc/logstash/files/filter/translate/test') }
    it { should contain_exec('create_files_dir_filter_translate_test').with(:command => 'mkdir -p /etc/logstash/files/filter/translate/test') }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :destination => 'value3',
      :dictionary => { 'field4' => 'value4' },
      :dictionary_path => 'puppet:///path/to/file5',
      :exact => false,
      :exclude_tags => ['value7'],
      :fallback => 'value8',
      :field => 'value9',
      :override => false,
      :regex => false,
      :remove_tag => ['value12'],
      :tags => ['value13'],
      :type => 'value14',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_translate_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_translate_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :destination => 'value3',
      :dictionary => { 'field4' => 'value4' },
      :dictionary_path => 'puppet:///path/to/file5',
      :exact => false,
      :exclude_tags => ['value7'],
      :fallback => 'value8',
      :field => 'value9',
      :override => false,
      :regex => false,
      :remove_tag => ['value12'],
      :tags => ['value13'],
      :type => 'value14',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_translate_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

require 'spec_helper'

describe 'logstash::output::gelf', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :chunksize => 1,
      :custom_fields => { 'field2' => 'value2' },
      :exclude_tags => ['value3'],
      :facility => 'value4',
      :fields => ['value5'],
      :file => 'value6',
      :full_message => 'value7',
      :host => 'value8',
      :ignore_metadata => ['value9'],
      :level => ['value10'],
      :line => 'value11',
      :port => 12,
      :sender => 'value13',
      :ship_metadata => false,
      :ship_tags => false,
      :short_message => 'value16',
      :tags => ['value17'],
      :type => 'value18',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_gelf_test').with(:content => "output {\n gelf {\n  chunksize => 1\n  custom_fields => [\"field2\", \"value2\"]\n  exclude_tags => ['value3']\n  facility => \"value4\"\n  fields => ['value5']\n  file => \"value6\"\n  full_message => \"value7\"\n  host => \"value8\"\n  ignore_metadata => ['value9']\n  level => ['value10']\n  line => \"value11\"\n  port => 12\n  sender => \"value13\"\n  ship_metadata => false\n  ship_tags => false\n  short_message => \"value16\"\n  tags => ['value17']\n  type => \"value18\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :chunksize => 1,
      :custom_fields => { 'field2' => 'value2' },
      :exclude_tags => ['value3'],
      :facility => 'value4',
      :fields => ['value5'],
      :file => 'value6',
      :full_message => 'value7',
      :host => 'value8',
      :ignore_metadata => ['value9'],
      :level => ['value10'],
      :line => 'value11',
      :port => 12,
      :sender => 'value13',
      :ship_metadata => false,
      :ship_tags => false,
      :short_message => 'value16',
      :tags => ['value17'],
      :type => 'value18',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_gelf_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_gelf_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :chunksize => 1,
      :custom_fields => { 'field2' => 'value2' },
      :exclude_tags => ['value3'],
      :facility => 'value4',
      :fields => ['value5'],
      :file => 'value6',
      :full_message => 'value7',
      :host => 'value8',
      :ignore_metadata => ['value9'],
      :level => ['value10'],
      :line => 'value11',
      :port => 12,
      :sender => 'value13',
      :ship_metadata => false,
      :ship_tags => false,
      :short_message => 'value16',
      :tags => ['value17'],
      :type => 'value18',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_gelf_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

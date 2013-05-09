require 'spec_helper'

describe 'logstash::filter::geoip', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :database => 'puppet:///path/to/file3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :remove_tag => ['value6'],
      :source => 'value7',
      :tags => ['value8'],
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_geoip_test').with(:content => "filter {\n geoip {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  database => \"/etc/logstash/files/filter/geoip/test/file3\"\n  exclude_tags => ['value4']\n  fields => ['value5']\n  remove_tag => ['value6']\n  source => \"value7\"\n  tags => ['value8']\n  type => \"value9\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/filter/geoip/test/file3').with(:source => 'puppet:///path/to/file3') }
    it { should contain_file('/etc/logstash/files/filter/geoip/test') }
    it { should contain_exec('create_files_dir_filter_geoip_test').with(:command => 'mkdir -p /etc/logstash/files/filter/geoip/test') }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :database => 'puppet:///path/to/file3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :remove_tag => ['value6'],
      :source => 'value7',
      :tags => ['value8'],
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_geoip_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_geoip_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :database => 'puppet:///path/to/file3',
      :exclude_tags => ['value4'],
      :fields => ['value5'],
      :remove_tag => ['value6'],
      :source => 'value7',
      :tags => ['value8'],
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_geoip_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

require 'spec_helper'

describe 'logstash::output::lumberjack', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :hosts => ['value3'],
      :port => 4,
      :ssl_certificate => 'puppet:///path/to/file5',
      :tags => ['value6'],
      :type => 'value7',
      :window_size => 8,
    } end

    it { should contain_file('/etc/logstash/agent/config/output_lumberjack_test').with(:content => "output {\n lumberjack {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  hosts => ['value3']\n  port => 4\n  ssl_certificate => \"/etc/logstash/files/output/lumberjack/test/file5\"\n  tags => ['value6']\n  type => \"value7\"\n  window_size => 8\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/output/lumberjack/test/file5').with(:source => 'puppet:///path/to/file5') }
    it { should contain_file('/etc/logstash/files/output/lumberjack/test') }
    it { should contain_exec('create_files_dir_output_lumberjack_test').with(:command => 'mkdir -p /etc/logstash/files/output/lumberjack/test') }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :hosts => ['value3'],
      :port => 4,
      :ssl_certificate => 'puppet:///path/to/file5',
      :tags => ['value6'],
      :type => 'value7',
      :window_size => 8,
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_lumberjack_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_lumberjack_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :hosts => ['value3'],
      :port => 4,
      :ssl_certificate => 'puppet:///path/to/file5',
      :tags => ['value6'],
      :type => 'value7',
      :window_size => 8,
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_lumberjack_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

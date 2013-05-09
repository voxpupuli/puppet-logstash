require 'spec_helper'

describe 'logstash::output::nagios', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :commandfile => 'puppet:///path/to/file1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :nagios_level => '0',
      :tags => ['value5'],
      :type => 'value6',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_nagios_test').with(:content => "output {\n nagios {\n  commandfile => \"/etc/logstash/files/output/nagios/test/file1\"\n  exclude_tags => ['value2']\n  fields => ['value3']\n  nagios_level => \"0\"\n  tags => ['value5']\n  type => \"value6\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/output/nagios/test/file1').with(:source => 'puppet:///path/to/file1') }
    it { should contain_file('/etc/logstash/files/output/nagios/test') }
    it { should contain_exec('create_files_dir_output_nagios_test').with(:command => 'mkdir -p /etc/logstash/files/output/nagios/test') }
  end

  context "Instance test" do

    let :params do {
      :commandfile => 'puppet:///path/to/file1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :nagios_level => '0',
      :tags => ['value5'],
      :type => 'value6',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_nagios_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_nagios_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :commandfile => 'puppet:///path/to/file1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :nagios_level => '0',
      :tags => ['value5'],
      :type => 'value6',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_nagios_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

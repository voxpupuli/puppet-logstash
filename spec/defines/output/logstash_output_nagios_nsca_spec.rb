require 'spec_helper'

describe 'logstash::output::nagios_nsca', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :nagios_host => 'value4',
      :nagios_service => 'value5',
      :nagios_status => 'value6',
      :port => 7,
      :send_nsca_bin => 'puppet:///path/to/file8',
      :send_nsca_config => 'puppet:///path/to/file9',
      :tags => ['value10'],
      :type => 'value11',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_nagios_nsca_test').with(:content => "output {\n nagios_nsca {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  host => \"value3\"\n  nagios_host => \"value4\"\n  nagios_service => \"value5\"\n  nagios_status => \"value6\"\n  port => 7\n  send_nsca_bin => \"/etc/logstash/files/output/nagios_nsca/test/file8\"\n  send_nsca_config => \"/etc/logstash/files/output/nagios_nsca/test/file9\"\n  tags => ['value10']\n  type => \"value11\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/output/nagios_nsca/test/file8').with(:source => 'puppet:///path/to/file8') }
    it { should contain_file('/etc/logstash/files/output/nagios_nsca/test/file9').with(:source => 'puppet:///path/to/file9') }
    it { should contain_file('/etc/logstash/files/output/nagios_nsca/test') }
    it { should contain_exec('create_files_dir_output_nagios_nsca_test').with(:command => 'mkdir -p /etc/logstash/files/output/nagios_nsca/test') }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :nagios_host => 'value4',
      :nagios_service => 'value5',
      :nagios_status => 'value6',
      :port => 7,
      :send_nsca_bin => 'puppet:///path/to/file8',
      :send_nsca_config => 'puppet:///path/to/file9',
      :tags => ['value10'],
      :type => 'value11',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_nagios_nsca_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_nagios_nsca_test') }

  end

end

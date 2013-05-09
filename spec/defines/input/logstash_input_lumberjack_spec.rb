require 'spec_helper'

describe 'logstash::input::lumberjack', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :message_format => 'value6',
      :port => 7,
      :ssl_certificate => 'puppet:///path/to/file8',
      :ssl_key => 'puppet:///path/to/file9',
      :ssl_key_passphrase => 'value10',
      :tags => ['value11'],
      :type => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_lumberjack_test').with(:content => "input {\n lumberjack {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  host => \"value5\"\n  message_format => \"value6\"\n  port => 7\n  ssl_certificate => \"/etc/logstash/files/input/lumberjack/test/file8\"\n  ssl_key => \"/etc/logstash/files/input/lumberjack/test/file9\"\n  ssl_key_passphrase => \"value10\"\n  tags => ['value11']\n  type => \"value12\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/input/lumberjack/test/file8').with(:source => 'puppet:///path/to/file8') }
    it { should contain_file('/etc/logstash/files/input/lumberjack/test/file9').with(:source => 'puppet:///path/to/file9') }
    it { should contain_file('/etc/logstash/files/input/lumberjack/test') }
    it { should contain_exec('create_files_dir_input_lumberjack_test').with(:command => 'mkdir -p /etc/logstash/files/input/lumberjack/test') }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :message_format => 'value6',
      :port => 7,
      :ssl_certificate => 'puppet:///path/to/file8',
      :ssl_key => 'puppet:///path/to/file9',
      :ssl_key_passphrase => 'value10',
      :tags => ['value11'],
      :type => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_lumberjack_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_lumberjack_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :message_format => 'value6',
      :port => 7,
      :ssl_certificate => 'puppet:///path/to/file8',
      :ssl_key => 'puppet:///path/to/file9',
      :ssl_key_passphrase => 'value10',
      :tags => ['value11'],
      :type => 'value12',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_lumberjack_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

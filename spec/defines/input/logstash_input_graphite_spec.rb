require 'spec_helper'

describe 'logstash::input::graphite', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :data_timeout => 3,
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :mode => 'server',
      :port => 9,
      :ssl_cacert => 'puppet:///path/to/file10',
      :ssl_cert => 'puppet:///path/to/file11',
      :ssl_enable => false,
      :ssl_key => 'puppet:///path/to/file13',
      :ssl_key_passphrase => 'value14',
      :ssl_verify => false,
      :tags => ['value16'],
      :type => 'value17',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_graphite_test').with(:content => "input {\n graphite {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  data_timeout => 3\n  debug => false\n  format => \"plain\"\n  host => \"value6\"\n  message_format => \"value7\"\n  mode => \"server\"\n  port => 9\n  ssl_cacert => \"/etc/logstash/files/input/graphite/test/file10\"\n  ssl_cert => \"/etc/logstash/files/input/graphite/test/file11\"\n  ssl_enable => false\n  ssl_key => \"/etc/logstash/files/input/graphite/test/file13\"\n  ssl_key_passphrase => \"value14\"\n  ssl_verify => false\n  tags => ['value16']\n  type => \"value17\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/input/graphite/test/file10').with(:source => 'puppet:///path/to/file10') }
    it { should contain_file('/etc/logstash/files/input/graphite/test/file11').with(:source => 'puppet:///path/to/file11') }
    it { should contain_file('/etc/logstash/files/input/graphite/test/file13').with(:source => 'puppet:///path/to/file13') }
    it { should contain_file('/etc/logstash/files/input/graphite/test') }
    it { should contain_exec('create_files_dir_input_graphite_test').with(:command => 'mkdir -p /etc/logstash/files/input/graphite/test') }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :data_timeout => 3,
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :mode => 'server',
      :port => 9,
      :ssl_cacert => 'puppet:///path/to/file10',
      :ssl_cert => 'puppet:///path/to/file11',
      :ssl_enable => false,
      :ssl_key => 'puppet:///path/to/file13',
      :ssl_key_passphrase => 'value14',
      :ssl_verify => false,
      :tags => ['value16'],
      :type => 'value17',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_graphite_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_graphite_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :data_timeout => 3,
      :debug => false,
      :format => 'plain',
      :host => 'value6',
      :message_format => 'value7',
      :mode => 'server',
      :port => 9,
      :ssl_cacert => 'puppet:///path/to/file10',
      :ssl_cert => 'puppet:///path/to/file11',
      :ssl_enable => false,
      :ssl_key => 'puppet:///path/to/file13',
      :ssl_key_passphrase => 'value14',
      :ssl_verify => false,
      :tags => ['value16'],
      :type => 'value17',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_graphite_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

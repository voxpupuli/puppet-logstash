require 'spec_helper'

describe 'logstash::input::file', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :discover_interval => 4,
      :exclude => ['value5'],
      :format => 'plain',
      :message_format => 'value7',
      :path => ['value8'],
      :sincedb_path => 'value9',
      :sincedb_write_interval => 10,
      :start_position => 'beginning',
      :stat_interval => 12,
      :tags => ['value13'],
      :type => 'value14',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_file_test').with(:content => "input {\n file {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  discover_interval => 4\n  exclude => ['value5']\n  format => \"plain\"\n  message_format => \"value7\"\n  path => ['value8']\n  sincedb_path => \"value9\"\n  sincedb_write_interval => 10\n  start_position => \"beginning\"\n  stat_interval => 12\n  tags => ['value13']\n  type => \"value14\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :discover_interval => 4,
      :exclude => ['value5'],
      :format => 'plain',
      :message_format => 'value7',
      :path => ['value8'],
      :sincedb_path => 'value9',
      :sincedb_write_interval => 10,
      :start_position => 'beginning',
      :stat_interval => 12,
      :tags => ['value13'],
      :type => 'value14',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_file_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_file_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :discover_interval => 4,
      :exclude => ['value5'],
      :format => 'plain',
      :message_format => 'value7',
      :path => ['value8'],
      :sincedb_path => 'value9',
      :sincedb_write_interval => 10,
      :start_position => 'beginning',
      :stat_interval => 12,
      :tags => ['value13'],
      :type => 'value14',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_file_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

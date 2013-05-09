require 'spec_helper'

describe 'logstash::input::lumberjack2', :type => 'define' do

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
      :my_secret_key => 'puppet:///path/to/file7',
      :port => 8,
      :tags => ['value9'],
      :their_public_key => 'puppet:///path/to/file10',
      :threads => 11,
      :type => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_lumberjack2_test').with(:content => "input {\n lumberjack2 {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  host => \"value5\"\n  message_format => \"value6\"\n  my_secret_key => \"/etc/logstash/files/input/lumberjack2/test/file7\"\n  port => 8\n  tags => ['value9']\n  their_public_key => \"/etc/logstash/files/input/lumberjack2/test/file10\"\n  threads => 11\n  type => \"value12\"\n }\n}\n") }
    it { should contain_file('/etc/logstash/files/input/lumberjack2/test/file7').with(:source => 'puppet:///path/to/file7') }
    it { should contain_file('/etc/logstash/files/input/lumberjack2/test/file10').with(:source => 'puppet:///path/to/file10') }
    it { should contain_file('/etc/logstash/files/input/lumberjack2/test') }
    it { should contain_exec('create_files_dir_input_lumberjack2_test').with(:command => 'mkdir -p /etc/logstash/files/input/lumberjack2/test') }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :host => 'value5',
      :message_format => 'value6',
      :my_secret_key => 'puppet:///path/to/file7',
      :port => 8,
      :tags => ['value9'],
      :their_public_key => 'puppet:///path/to/file10',
      :threads => 11,
      :type => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_lumberjack2_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_lumberjack2_test') }

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
      :my_secret_key => 'puppet:///path/to/file7',
      :port => 8,
      :tags => ['value9'],
      :their_public_key => 'puppet:///path/to/file10',
      :threads => 11,
      :type => 'value12',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_lumberjack2_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

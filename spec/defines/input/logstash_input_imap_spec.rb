require 'spec_helper'

describe 'logstash::input::imap', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :check_interval => 3,
      :debug => false,
      :fetch_count => 5,
      :format => 'plain',
      :host => 'value7',
      :lowercase_headers => false,
      :message_format => 'value9',
      :password => 'value10',
      :port => 11,
      :secure => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_imap_test').with(:content => "input {\n imap {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  check_interval => 3\n  debug => false\n  fetch_count => 5\n  format => \"plain\"\n  host => \"value7\"\n  lowercase_headers => false\n  message_format => \"value9\"\n  password => \"value10\"\n  port => 11\n  secure => false\n  tags => ['value13']\n  type => \"value14\"\n  user => \"value15\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :check_interval => 3,
      :debug => false,
      :fetch_count => 5,
      :format => 'plain',
      :host => 'value7',
      :lowercase_headers => false,
      :message_format => 'value9',
      :password => 'value10',
      :port => 11,
      :secure => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_imap_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_imap_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :check_interval => 3,
      :debug => false,
      :fetch_count => 5,
      :format => 'plain',
      :host => 'value7',
      :lowercase_headers => false,
      :message_format => 'value9',
      :password => 'value10',
      :port => 11,
      :secure => false,
      :tags => ['value13'],
      :type => 'value14',
      :user => 'value15',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_imap_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

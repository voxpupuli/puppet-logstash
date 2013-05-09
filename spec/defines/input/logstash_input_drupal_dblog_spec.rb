require 'spec_helper'

describe 'logstash::input::drupal_dblog', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_usernames => false,
      :bulksize => 3,
      :charset => 'ASCII-8BIT',
      :databases => { 'field5' => 'value5' },
      :debug => false,
      :format => 'plain',
      :interval => 8,
      :message_format => 'value9',
      :tags => ['value10'],
      :type => 'value11',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_drupal_dblog_test').with(:content => "input {\n drupal_dblog {\n  add_field => [\"field1\", \"value1\"]\n  add_usernames => false\n  bulksize => 3\n  charset => \"ASCII-8BIT\"\n  databases => [\"field5\", \"value5\"]\n  debug => false\n  format => \"plain\"\n  interval => 8\n  message_format => \"value9\"\n  tags => ['value10']\n  type => \"value11\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_usernames => false,
      :bulksize => 3,
      :charset => 'ASCII-8BIT',
      :databases => { 'field5' => 'value5' },
      :debug => false,
      :format => 'plain',
      :interval => 8,
      :message_format => 'value9',
      :tags => ['value10'],
      :type => 'value11',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_drupal_dblog_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_drupal_dblog_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_usernames => false,
      :bulksize => 3,
      :charset => 'ASCII-8BIT',
      :databases => { 'field5' => 'value5' },
      :debug => false,
      :format => 'plain',
      :interval => 8,
      :message_format => 'value9',
      :tags => ['value10'],
      :type => 'value11',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_drupal_dblog_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

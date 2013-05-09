require 'spec_helper'

describe 'logstash::input::twitter', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :keywords => ['value5'],
      :message_format => 'value6',
      :password => 'value7',
      :proxy_host => 'value8',
      :proxy_password => 'value9',
      :proxy_port => 10,
      :proxy_user => 'value11',
      :tags => ['value12'],
      :type => 'value13',
      :user => 'value14',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_twitter_test').with(:content => "input {\n twitter {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  keywords => ['value5']\n  message_format => \"value6\"\n  password => \"value7\"\n  proxy_host => \"value8\"\n  proxy_password => \"value9\"\n  proxy_port => 10\n  proxy_user => \"value11\"\n  tags => ['value12']\n  type => \"value13\"\n  user => \"value14\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :debug => false,
      :format => 'plain',
      :keywords => ['value5'],
      :message_format => 'value6',
      :password => 'value7',
      :proxy_host => 'value8',
      :proxy_password => 'value9',
      :proxy_port => 10,
      :proxy_user => 'value11',
      :tags => ['value12'],
      :type => 'value13',
      :user => 'value14',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_twitter_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_twitter_test') }

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
      :keywords => ['value5'],
      :message_format => 'value6',
      :password => 'value7',
      :proxy_host => 'value8',
      :proxy_password => 'value9',
      :proxy_port => 10,
      :proxy_user => 'value11',
      :tags => ['value12'],
      :type => 'value13',
      :user => 'value14',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_twitter_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

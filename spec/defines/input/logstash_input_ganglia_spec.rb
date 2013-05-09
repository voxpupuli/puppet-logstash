require 'spec_helper'

describe 'logstash::input::ganglia', :type => 'define' do

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
      :tags => ['value8'],
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_ganglia_test').with(:content => "input {\n ganglia {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  debug => false\n  format => \"plain\"\n  host => \"value5\"\n  message_format => \"value6\"\n  port => 7\n  tags => ['value8']\n  type => \"value9\"\n }\n}\n") }
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
      :tags => ['value8'],
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_ganglia_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_ganglia_test') }

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
      :tags => ['value8'],
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_ganglia_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

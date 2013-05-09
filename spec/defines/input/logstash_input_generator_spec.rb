require 'spec_helper'

describe 'logstash::input::generator', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :count => 3,
      :debug => false,
      :format => 'plain',
      :lines => ['value6'],
      :message => 'value7',
      :message_format => 'value8',
      :tags => ['value9'],
      :threads => 10,
      :type => 'value11',
    } end

    it { should contain_file('/etc/logstash/agent/config/input_generator_test').with(:content => "input {\n generator {\n  add_field => [\"field1\", \"value1\"]\n  charset => \"ASCII-8BIT\"\n  count => 3\n  debug => false\n  format => \"plain\"\n  lines => ['value6']\n  message => \"value7\"\n  message_format => \"value8\"\n  tags => ['value9']\n  threads => 10\n  type => \"value11\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :count => 3,
      :debug => false,
      :format => 'plain',
      :lines => ['value6'],
      :message => 'value7',
      :message_format => 'value8',
      :tags => ['value9'],
      :threads => 10,
      :type => 'value11',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/input_generator_test') }
    it { should contain_file('/etc/logstash/agent2/config/input_generator_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :charset => 'ASCII-8BIT',
      :count => 3,
      :debug => false,
      :format => 'plain',
      :lines => ['value6'],
      :message => 'value7',
      :message_format => 'value8',
      :tags => ['value9'],
      :threads => 10,
      :type => 'value11',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/input_generator_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

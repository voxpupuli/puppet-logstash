require 'spec_helper'

describe 'logstash::output::irc', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :channels => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :host => 'value5',
      :nick => 'value6',
      :password => 'value7',
      :port => 8,
      :real => 'value9',
      :secure => false,
      :tags => ['value11'],
      :type => 'value12',
      :user => 'value13',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_irc_test').with(:content => "output {\n irc {\n  channels => ['value1']\n  exclude_tags => ['value2']\n  fields => ['value3']\n  format => \"value4\"\n  host => \"value5\"\n  nick => \"value6\"\n  password => \"value7\"\n  port => 8\n  real => \"value9\"\n  secure => false\n  tags => ['value11']\n  type => \"value12\"\n  user => \"value13\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :channels => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :host => 'value5',
      :nick => 'value6',
      :password => 'value7',
      :port => 8,
      :real => 'value9',
      :secure => false,
      :tags => ['value11'],
      :type => 'value12',
      :user => 'value13',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_irc_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_irc_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :channels => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :host => 'value5',
      :nick => 'value6',
      :password => 'value7',
      :port => 8,
      :real => 'value9',
      :secure => false,
      :tags => ['value11'],
      :type => 'value12',
      :user => 'value13',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_irc_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

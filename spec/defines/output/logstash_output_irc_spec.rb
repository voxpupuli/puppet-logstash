require 'spec_helper'

describe 'logstash::output::irc', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS',
                 :osfamily        => 'Linux'} }
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :channels => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :host => 'value5',
      :messages_per_second => 6,
      :nick => 'value7',
      :password => 'value8',
      :port => 9,
      :real => 'value10',
      :secure => false,
      :tags => ['value12'],
      :type => 'value13',
      :user => 'value14',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_irc_test').with(:content => "output {\n irc {\n  channels => ['value1']\n  exclude_tags => ['value2']\n  fields => ['value3']\n  format => \"value4\"\n  host => \"value5\"\n  messages_per_second => 6\n  nick => \"value7\"\n  password => \"value8\"\n  port => 9\n  real => \"value10\"\n  secure => false\n  tags => ['value12']\n  type => \"value13\"\n  user => \"value14\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :channels => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :host => 'value5',
      :messages_per_second => 6,
      :nick => 'value7',
      :password => 'value8',
      :port => 9,
      :real => 'value10',
      :secure => false,
      :tags => ['value12'],
      :type => 'value13',
      :user => 'value14',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_irc_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_irc_test') }

  end

  context "Set file owner" do

      let(:facts) { {:operatingsystem => 'CentOS',
                     :osfamily        => 'Linux'} }
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :channels => ['value1'],
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :host => 'value5',
      :messages_per_second => 6,
      :nick => 'value7',
      :password => 'value8',
      :port => 9,
      :real => 'value10',
      :secure => false,
      :tags => ['value12'],
      :type => 'value13',
      :user => 'value14',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_irc_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

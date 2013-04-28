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
      :tags => ['value10'],
      :type => 'value11',
      :user => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_irc_test').with(:content => "output {\n irc {\n  channels => ['value1']\n  exclude_tags => ['value2']\n  fields => ['value3']\n  format => \"value4\"\n  host => \"value5\"\n  nick => \"value6\"\n  password => \"value7\"\n  port => 8\n  real => \"value9\"\n  tags => ['value10']\n  type => \"value11\"\n  user => \"value12\"\n }\n}\n") }
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
      :tags => ['value10'],
      :type => 'value11',
      :user => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_irc_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_irc_test') }

  end

end

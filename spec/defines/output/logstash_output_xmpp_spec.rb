require 'spec_helper'

describe 'logstash::output::xmpp', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :message => 'value4',
      :password => 'value5',
      :rooms => ['value6'],
      :tags => ['value7'],
      :type => 'value8',
      :user => 'value9',
      :users => ['value10'],
    } end

    it { should contain_file('/etc/logstash/agent/config/output_xmpp_test').with(:content => "output {\n xmpp {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  host => \"value3\"\n  message => \"value4\"\n  password => \"value5\"\n  rooms => ['value6']\n  tags => ['value7']\n  type => \"value8\"\n  user => \"value9\"\n  users => ['value10']\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :message => 'value4',
      :password => 'value5',
      :rooms => ['value6'],
      :tags => ['value7'],
      :type => 'value8',
      :user => 'value9',
      :users => ['value10'],
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_xmpp_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_xmpp_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :message => 'value4',
      :password => 'value5',
      :rooms => ['value6'],
      :tags => ['value7'],
      :type => 'value8',
      :user => 'value9',
      :users => ['value10'],
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_xmpp_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

require 'spec_helper'

describe 'logstash::output::hipchat', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :color => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :from => 'value5',
      :room_id => 'value6',
      :tags => ['value7'],
      :token => 'value8',
      :trigger_notify => false,
      :type => 'value10',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_hipchat_test').with(:content => "output {\n hipchat {\n  color => \"value1\"\n  exclude_tags => ['value2']\n  fields => ['value3']\n  format => \"value4\"\n  from => \"value5\"\n  room_id => \"value6\"\n  tags => ['value7']\n  token => \"value8\"\n  trigger_notify => false\n  type => \"value10\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :color => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :from => 'value5',
      :room_id => 'value6',
      :tags => ['value7'],
      :token => 'value8',
      :trigger_notify => false,
      :type => 'value10',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_hipchat_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_hipchat_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :color => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'value4',
      :from => 'value5',
      :room_id => 'value6',
      :tags => ['value7'],
      :token => 'value8',
      :trigger_notify => false,
      :type => 'value10',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_hipchat_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

require 'spec_helper'

describe 'logstash::output::loggly', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :key => 'value4',
      :proto => 'value5',
      :proxy_host => 'value6',
      :proxy_password => 'value7',
      :proxy_port => 8,
      :proxy_user => 'value9',
      :tags => ['value10'],
      :type => 'value11',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_loggly_test').with(:content => "output {\n loggly {\n  exclude_tags => ['value1']\n  fields => ['value2']\n  host => \"value3\"\n  key => \"value4\"\n  proto => \"value5\"\n  proxy_host => \"value6\"\n  proxy_password => \"value7\"\n  proxy_port => 8\n  proxy_user => \"value9\"\n  tags => ['value10']\n  type => \"value11\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :key => 'value4',
      :proto => 'value5',
      :proxy_host => 'value6',
      :proxy_password => 'value7',
      :proxy_port => 8,
      :proxy_user => 'value9',
      :tags => ['value10'],
      :type => 'value11',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_loggly_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_loggly_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :exclude_tags => ['value1'],
      :fields => ['value2'],
      :host => 'value3',
      :key => 'value4',
      :proto => 'value5',
      :proxy_host => 'value6',
      :proxy_password => 'value7',
      :proxy_port => 8,
      :proxy_user => 'value9',
      :tags => ['value10'],
      :type => 'value11',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_loggly_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

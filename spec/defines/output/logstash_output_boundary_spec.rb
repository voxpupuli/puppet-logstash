require 'spec_helper'

describe 'logstash::output::boundary', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :api_key => 'value1',
      :auto => false,
      :bsubtype => 'value3',
      :btags => ['value4'],
      :btype => 'value5',
      :end_time => 'value6',
      :exclude_tags => ['value7'],
      :fields => ['value8'],
      :org_id => 'value9',
      :start_time => 'value10',
      :tags => ['value11'],
      :type => 'value12',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_boundary_test').with(:content => "output {\n boundary {\n  api_key => \"value1\"\n  auto => false\n  bsubtype => \"value3\"\n  btags => ['value4']\n  btype => \"value5\"\n  end_time => \"value6\"\n  exclude_tags => ['value7']\n  fields => ['value8']\n  org_id => \"value9\"\n  start_time => \"value10\"\n  tags => ['value11']\n  type => \"value12\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :api_key => 'value1',
      :auto => false,
      :bsubtype => 'value3',
      :btags => ['value4'],
      :btype => 'value5',
      :end_time => 'value6',
      :exclude_tags => ['value7'],
      :fields => ['value8'],
      :org_id => 'value9',
      :start_time => 'value10',
      :tags => ['value11'],
      :type => 'value12',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_boundary_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_boundary_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :api_key => 'value1',
      :auto => false,
      :bsubtype => 'value3',
      :btags => ['value4'],
      :btype => 'value5',
      :end_time => 'value6',
      :exclude_tags => ['value7'],
      :fields => ['value8'],
      :org_id => 'value9',
      :start_time => 'value10',
      :tags => ['value11'],
      :type => 'value12',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_boundary_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

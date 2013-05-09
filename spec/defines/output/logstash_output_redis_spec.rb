require 'spec_helper'

describe 'logstash::output::redis', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :batch => false,
      :batch_events => 2,
      :batch_timeout => 3,
      :congestion_interval => 4,
      :congestion_threshold => 5,
      :data_type => 'list',
      :db => 7,
      :exclude_tags => ['value8'],
      :fields => ['value9'],
      :host => ['value10'],
      :key => 'value11',
      :password => 'value12',
      :port => 13,
      :reconnect_interval => 14,
      :shuffle_hosts => false,
      :tags => ['value16'],
      :timeout => 17,
      :type => 'value18',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_redis_test').with(:content => "output {\n redis {\n  batch => false\n  batch_events => 2\n  batch_timeout => 3\n  congestion_interval => 4\n  congestion_threshold => 5\n  data_type => \"list\"\n  db => 7\n  exclude_tags => ['value8']\n  fields => ['value9']\n  host => ['value10']\n  key => \"value11\"\n  password => \"value12\"\n  port => 13\n  reconnect_interval => 14\n  shuffle_hosts => false\n  tags => ['value16']\n  timeout => 17\n  type => \"value18\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :batch => false,
      :batch_events => 2,
      :batch_timeout => 3,
      :congestion_interval => 4,
      :congestion_threshold => 5,
      :data_type => 'list',
      :db => 7,
      :exclude_tags => ['value8'],
      :fields => ['value9'],
      :host => ['value10'],
      :key => 'value11',
      :password => 'value12',
      :port => 13,
      :reconnect_interval => 14,
      :shuffle_hosts => false,
      :tags => ['value16'],
      :timeout => 17,
      :type => 'value18',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_redis_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_redis_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :batch => false,
      :batch_events => 2,
      :batch_timeout => 3,
      :congestion_interval => 4,
      :congestion_threshold => 5,
      :data_type => 'list',
      :db => 7,
      :exclude_tags => ['value8'],
      :fields => ['value9'],
      :host => ['value10'],
      :key => 'value11',
      :password => 'value12',
      :port => 13,
      :reconnect_interval => 14,
      :shuffle_hosts => false,
      :tags => ['value16'],
      :timeout => 17,
      :type => 'value18',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_redis_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

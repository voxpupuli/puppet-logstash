require 'spec_helper'

describe 'logstash::filter::dns', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :action => 'append',
      :add_field => { 'field2' => 'value2' },
      :add_tag => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :resolve => ['value6'],
      :reverse => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_dns_test').with(:content => "filter {\n dns {\n  action => \"append\"\n  add_field => [\"field2\", \"value2\"]\n  add_tag => ['value3']\n  exclude_tags => ['value4']\n  remove_tag => ['value5']\n  resolve => ['value6']\n  reverse => ['value7']\n  tags => ['value8']\n  type => \"value9\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :action => 'append',
      :add_field => { 'field2' => 'value2' },
      :add_tag => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :resolve => ['value6'],
      :reverse => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_dns_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_dns_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :action => 'append',
      :add_field => { 'field2' => 'value2' },
      :add_tag => ['value3'],
      :exclude_tags => ['value4'],
      :remove_tag => ['value5'],
      :resolve => ['value6'],
      :reverse => ['value7'],
      :tags => ['value8'],
      :type => 'value9',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_dns_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

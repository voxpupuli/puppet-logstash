require 'spec_helper'

describe 'logstash::filter::mutate', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :convert => { 'field3' => 'value3' },
      :exclude_tags => ['value4'],
      :gsub => ['value5'],
      :join => { 'field6' => 'value6' },
      :lowercase => ['value7'],
      :merge => { 'field8' => 'value8' },
      :remove => ['value9'],
      :remove_tag => ['value10'],
      :rename => { 'field11' => 'value11' },
      :replace => { 'field12' => 'value12' },
      :split => { 'field13' => 'value13' },
      :strip => ['value14'],
      :tags => ['value15'],
      :type => 'value16',
      :update => { 'field17' => 'value17' },
      :uppercase => ['value18'],
    } end

    it { should contain_file('/etc/logstash/agent/config/filter_10_mutate_test').with(:content => "filter {\n mutate {\n  add_field => [\"field1\", \"value1\"]\n  add_tag => ['value2']\n  convert => [\"field3\", \"value3\"]\n  exclude_tags => ['value4']\n  gsub => ['value5']\n  join => [\"field6\", \"value6\"]\n  lowercase => ['value7']\n  merge => [\"field8\", \"value8\"]\n  remove => ['value9']\n  remove_tag => ['value10']\n  rename => [\"field11\", \"value11\"]\n  replace => [\"field12\", \"value12\"]\n  split => [\"field13\", \"value13\"]\n  strip => ['value14']\n  tags => ['value15']\n  type => \"value16\"\n  update => [\"field17\", \"value17\"]\n  uppercase => ['value18']\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :convert => { 'field3' => 'value3' },
      :exclude_tags => ['value4'],
      :gsub => ['value5'],
      :join => { 'field6' => 'value6' },
      :lowercase => ['value7'],
      :merge => { 'field8' => 'value8' },
      :remove => ['value9'],
      :remove_tag => ['value10'],
      :rename => { 'field11' => 'value11' },
      :replace => { 'field12' => 'value12' },
      :split => { 'field13' => 'value13' },
      :strip => ['value14'],
      :tags => ['value15'],
      :type => 'value16',
      :update => { 'field17' => 'value17' },
      :uppercase => ['value18'],
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/filter_10_mutate_test') }
    it { should contain_file('/etc/logstash/agent2/config/filter_10_mutate_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :add_field => { 'field1' => 'value1' },
      :add_tag => ['value2'],
      :convert => { 'field3' => 'value3' },
      :exclude_tags => ['value4'],
      :gsub => ['value5'],
      :join => { 'field6' => 'value6' },
      :lowercase => ['value7'],
      :merge => { 'field8' => 'value8' },
      :remove => ['value9'],
      :remove_tag => ['value10'],
      :rename => { 'field11' => 'value11' },
      :replace => { 'field12' => 'value12' },
      :split => { 'field13' => 'value13' },
      :strip => ['value14'],
      :tags => ['value15'],
      :type => 'value16',
      :update => { 'field17' => 'value17' },
      :uppercase => ['value18'],
    } end
  
    it { should contain_file('/etc/logstash/agent/config/filter_10_mutate_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

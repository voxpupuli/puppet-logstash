require 'spec_helper'

describe 'logstash::output::http', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :content_type => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'json',
      :headers => { 'field5' => 'value5' },
      :http_method => 'put',
      :mapping => { 'field7' => 'value7' },
      :message => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :url => 'value11',
      :verify_ssl => false,
    } end

    it { should contain_file('/etc/logstash/agent/config/output_http_test').with(:content => "output {\n http {\n  content_type => \"value1\"\n  exclude_tags => ['value2']\n  fields => ['value3']\n  format => \"json\"\n  headers => [\"field5\", \"value5\"]\n  http_method => \"put\"\n  mapping => [\"field7\", \"value7\"]\n  message => \"value8\"\n  tags => ['value9']\n  type => \"value10\"\n  url => \"value11\"\n  verify_ssl => false\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :content_type => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'json',
      :headers => { 'field5' => 'value5' },
      :http_method => 'put',
      :mapping => { 'field7' => 'value7' },
      :message => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :url => 'value11',
      :verify_ssl => false,
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_http_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_http_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :content_type => 'value1',
      :exclude_tags => ['value2'],
      :fields => ['value3'],
      :format => 'json',
      :headers => { 'field5' => 'value5' },
      :http_method => 'put',
      :mapping => { 'field7' => 'value7' },
      :message => 'value8',
      :tags => ['value9'],
      :type => 'value10',
      :url => 'value11',
      :verify_ssl => false,
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_http_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

require 'spec_helper'

describe 'logstash::output::email', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' }}
  let(:pre_condition) { 'class {"logstash": }'}
  let(:title) { 'test' }

  context "Input test" do

    let :params do {
      :attachments => ['value1'],
      :body => 'value2',
      :cc => 'value3',
      :contenttype => 'value4',
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :from => 'value7',
      :htmlbody => 'value8',
      :match => { 'field9' => 'value9' },
      :options => { 'field10' => 'value10' },
      :subject => 'value11',
      :tags => ['value12'],
      :to => 'value13',
      :type => 'value14',
      :via => 'value15',
    } end

    it { should contain_file('/etc/logstash/agent/config/output_email_test').with(:content => "output {\n email {\n  attachments => ['value1']\n  body => \"value2\"\n  cc => \"value3\"\n  contenttype => \"value4\"\n  exclude_tags => ['value5']\n  fields => ['value6']\n  from => \"value7\"\n  htmlbody => \"value8\"\n  match => [\"field9\", \"value9\"]\n  options => [\"field10\", \"value10\"]\n  subject => \"value11\"\n  tags => ['value12']\n  to => \"value13\"\n  type => \"value14\"\n  via => \"value15\"\n }\n}\n") }
  end

  context "Instance test" do

    let :params do {
      :attachments => ['value1'],
      :body => 'value2',
      :cc => 'value3',
      :contenttype => 'value4',
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :from => 'value7',
      :htmlbody => 'value8',
      :match => { 'field9' => 'value9' },
      :options => { 'field10' => 'value10' },
      :subject => 'value11',
      :tags => ['value12'],
      :to => 'value13',
      :type => 'value14',
      :via => 'value15',
      :instances => [ 'agent1', 'agent2' ]
    } end
  
    it { should contain_file('/etc/logstash/agent1/config/output_email_test') }
    it { should contain_file('/etc/logstash/agent2/config/output_email_test') }

  end

  context "Set file owner" do

    let(:facts) { {:operatingsystem => 'CentOS' }}
    let(:pre_condition) { 'class {"logstash": logstash_user => "logstash", logstash_group => "logstash" }'}
    let(:title) { 'test' }

    let :params do {
      :attachments => ['value1'],
      :body => 'value2',
      :cc => 'value3',
      :contenttype => 'value4',
      :exclude_tags => ['value5'],
      :fields => ['value6'],
      :from => 'value7',
      :htmlbody => 'value8',
      :match => { 'field9' => 'value9' },
      :options => { 'field10' => 'value10' },
      :subject => 'value11',
      :tags => ['value12'],
      :to => 'value13',
      :type => 'value14',
      :via => 'value15',
    } end
  
    it { should contain_file('/etc/logstash/agent/config/output_email_test').with(:owner => 'logstash', :group => 'logstash') }

  end

end

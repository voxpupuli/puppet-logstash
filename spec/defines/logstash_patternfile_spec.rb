require 'spec_helper'

describe 'logstash::patternfile', :type => 'define' do

  let(:facts) { {:operatingsystem => 'CentOS' } }
  let(:title) { 'foopatterns' }

  context 'multi_instance = true' do
    let(:pre_condition) { 'class {"logstash": multi_instance => true}'}

    context 'with instance name' do
      let(:params) { {
        :source   => 'puppet:///mypatterns',
        :instance => 'indexer'
      } }
      it { should contain_file('/etc/logstash/indexer/config/patterns/mypatterns').with( :source => 'puppet:///mypatterns') }
    end

    context 'set filename' do
      let(:params) { {
        :source   => 'puppet:///mypatterns',
        :instance => 'indexer',
        :filename => 'pattern123'
      } }
      it { should contain_file('/etc/logstash/indexer/config/patterns/pattern123')}
    end

    context 'wtihout instance name' do
      let(:params) { {
        :source   => 'puppet:///mypatterns'
      } }
      it { expect { should raise_error(Puppet::Error) } }
    end

    context 'with bad source' do
      let(:params) { {
        :source   => 'http://mypatterns',
        :instance => 'indexer'
      } }
      it { expect { should raise_error(Puppet::Error) } }
    end

  end

  context 'multi_instance = false' do
    let(:pre_condition) { 'class {"logstash": multi_instance => false}'}

    context 'wtihout instance name' do
      let(:params) { {
        :source   => 'puppet:///mypatterns'
      } }
      it { should contain_file('/etc/logstash/conf.d/patterns/mypatterns').with( :source => 'puppet:///mypatterns') }
    end

    context 'set filename' do
      let(:params) { {
        :source   => 'puppet:///mypatterns',
        :filename => 'pattern123'
      } }
      it { should contain_file('/etc/logstash/conf.d/patterns/pattern123')}
    end

    context 'with instance name' do
      let(:params) { {
        :source   => 'puppet:///mypatterns',
        :instance => 'indexer'
      } }
      it { expect { should raise_error(Puppet::Error) } }
    end

    context 'with bad source' do
      let(:params) { {
        :source   => 'http://mypatterns',
        :instance => 'indexer'
      } }
      it { expect { should raise_error(Puppet::Error) } }
    end
  end
end


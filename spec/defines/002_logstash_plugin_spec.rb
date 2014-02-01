require 'spec_helper'

describe 'logstash::plugin', :type => 'define' do

  let :facts do {
    :operatingsystem => 'CentOS',
    :kernel => 'Linux'
  } end
  
  let(:title) { 'fooplugin' }

  let(:pre_condition) { 'class {"logstash": }'}

  [ 'input', 'output', 'filter', 'codec' ].each do |plugin_type|

    context "for #{plugin_type}" do

      context 'Default call' do

        let(:params) { {
          :ensure   => 'present',
          :source   => 'puppet:///path/to/plugin.rb',
          :type     => plugin_type 
        } }

        it { should contain_logstash__plugin('fooplugin') }
        it { should contain_file("/etc/logstash/plugins/logstash/#{plugin_type}s/plugin.rb").with( :source => 'puppet:///path/to/plugin.rb') }

      end

      context 'set filename' do

        let(:params) { {
          :ensure   => 'present',
          :source   => 'puppet:///path/to/plugin_v1.rb',
          :type     => plugin_type,
          :filename => 'plugin.rb'
        } }

        it { should contain_logstash__plugin('fooplugin') }
        it { should contain_file("/etc/logstash/plugins/logstash/#{plugin_type}s/plugin.rb").with( :source => 'puppet:///path/to/plugin_v1.rb') }

      end

    end

  end

  context 'with bad source' do

    let(:params) { {
      :ensure   => 'present',
      :source   => 'http://mypatterns',
    } }

    it { expect { should raise_error(Puppet::Error) } }

  end

  context 'with bad plugin type' do

    let(:params) { {
      :ensure   => 'present',
      :source   => 'puppet:///path/to/plugin.rb',
      :type     => 'dontexist' 
    } }

    it { expect { should raise_error(Puppet::Error) } }

  end

end

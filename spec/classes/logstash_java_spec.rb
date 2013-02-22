require 'spec_helper'

describe 'logstash::java', :type => 'class' do

  context "On a Debian OS" do
    let :facts do
      {
        :operatingsystem => 'Debian'
      }
    end
   
    it { should contain_package('openjdk-6-jre-headless') }
 
  end

   context "On an Ubuntu OS" do
    let :facts do
      {
        :operatingsystem => 'Ubuntu'
      }
    end

    it { should contain_package('openjdk-6-jre-headless') }

  end

  context "On a CentOS OS " do
    let :facts do
      {
        :operatingsystem => 'CentOS'
      }
    end

    it { should contain_package('java-1.6.0-openjdk') }

  end

  context "On a RedHat OS " do
    let :facts do
      {
        :operatingsystem => 'Redhat'
      }
    end

    it { should contain_package('java-1.6.0-openjdk') }

  end

  context "On a Fedora OS " do
    let :facts do
      {
        :operatingsystem => 'Fedora'
      }
    end

    it { should contain_package('java-1.6.0-openjdk') }
  
  end

  context "On a Scientific OS " do
    let :facts do
      {
        :operatingsystem => 'Scientific'
      }
    end

    it { should contain_package('java-1.6.0-openjdk') }
   
  end

  context "On a Amazon OS " do
    let :facts do
      {
        :operatingsystem => 'Amazon'
      }
    end

    it { should contain_package('java-1.6.0-openjdk') }
   
  end

  context "On an unknown OS" do
    let :facts do
      {
        :operatingsystem => 'Darwin'
      }
    end
 
    it {
      expect { should raise_error(Puppet::Error) }
    }
  end
  context "Custom java package" do
    let :facts do
      {
        :operatingsystem => 'CentOS'
      }
    end

    let :params do {
      :'logstash::java_package' => 'java-1.7.0-openjdk'
    } end
    it { should contain_package('java-1.7.0-openjdk') }

  end
end

require 'beaker-rspec'
require 'pry'
require 'securerandom'

files_dir = ENV['files_dir'] || '/home/jenkins/puppet'

proxy_host = ENV['proxy_host'] || ''

gem_proxy = ''
gem_proxy = "http_proxy=http://#{proxy_host}" unless proxy_host.empty?

if !proxy_host.empty?
  hosts.each do |host|
    case host['platform']
    when /ubuntu/, /debian/
      on host, "echo 'Acquire::http::Proxy \"http://#{proxy_host}/\";' >> /etc/apt/apt.conf.d/10proxy"
    when /^el-/, /centos/, /fedora/, /redhat/
      on host, "echo 'proxy=http://#{proxy_host}/' >> /etc/yum.conf"
    end
    on host, "echo 'export http_proxy=\"http://#{proxy_host}\"' >> /root/.bashrc"
    on host, "echo 'export https_proxy=\"http://#{proxy_host}\"' >> /root/.bashrc"
    on host, "echo 'export no_proxy=\"localhost,127.0.0.1,localaddress,.localdomain.com,#{host.name}\"' >> /root/.bashrc"
  end
end

hosts.each do |host|
  # Install Puppet
  if host.is_pe?
    on host, "hostname #{host.name}"
    install_pe
  else
    puppetversion = ENV['VM_PUPPET_VERSION']
    on host, "#{gem_proxy} gem install puppet --no-ri --no-rdoc --version '~> #{puppetversion}'"
    on host, "mkdir -p #{host['distmoduledir']}"

    if fact('osfamily') == 'Suse'
      if fact('operatingsystem') == 'OpenSuSE'
        install_package host, 'ruby-devel augeas-devel libxml2-devel'
        on host, "#{gem_proxy} gem install ruby-augeas --no-ri --no-rdoc"
      end
    end

  end

  # Copy over some files
  if fact('osfamily') == 'Debian'
    scp_to(host, "#{files_dir}/logstash_1.4.2-1-2c0f5a1_all.deb", '/tmp/logstash_1.4.2-1-2c0f5a1_all.deb')
  end

  if fact('osfamily') == 'RedHat'
    scp_to(host, "#{files_dir}/logstash-1.4.2-1_2c0f5a1.noarch.rpm", '/tmp/logstash-1.4.2-1_2c0f5a1.noarch.rpm')
  end

  if fact('osfamily') == 'Suse'
    scp_to(host, "#{files_dir}/logstash-1.4.2-1_2c0f5a1.noarch.rpm", '/tmp/logstash-1.4.2-1_2c0f5a1.noarch.rpm')
  end


  # on debian/ubuntu nodes ensure we get the latest info
  # Can happen we have stalled data in the images
  if fact('osfamily') == 'Debian'
    on host, "apt-get update"
  end

end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # declare an exclusion filter
  c.filter_run_excluding :broken => true

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'logstash')
    hosts.each do |host|

      on host, puppet('module','install','puppetlabs-concat'), { :acceptable_exit_codes => [0,1] }

      if !host.is_pe?
        scp_to(host, '/home/jenkins/puppet/puppetlabs-stdlib-3.2.0.tar.gz', '/tmp/puppetlabs-stdlib-3.2.0.tar.gz')
        on host, puppet('module','install','/tmp/puppetlabs-stdlib-3.2.0.tar.gz'), { :acceptable_exit_codes => [0,1] }
      end
      if fact('osfamily') == 'Debian'
        if !host.is_pe?
          scp_to(host, '/home/jenkins/puppet/puppetlabs-apt-1.4.2.tar.gz', '/tmp/puppetlabs-apt-1.4.2.tar.gz')
          on host, puppet('module','install','/tmp/puppetlabs-apt-1.4.2.tar.gz'), { :acceptable_exit_codes => [0,1] }
        end
      end
      if fact('osfamily') == 'Suse'
        on host, puppet('module','install','darin-zypprepo'), { :acceptable_exit_codes => [0,1] }
      end

    end
  end
end

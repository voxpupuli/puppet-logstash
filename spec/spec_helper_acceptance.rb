require 'beaker-rspec'
require 'pry'
require 'securerandom'

files_dir = './spec/fixtures/artifacts'

# Collect global options from the environment.
raise "Please set the BEAKER_ls_version environment variable." if ENV['BEAKER_ls_version'].nil?
LS_VERSION = ENV['BEAKER_ls_version']

hosts.each do |host|
  # Install Puppet
  if host.is_pe?
    on host, "hostname #{host.name}"
    install_pe
  else
    install_puppet_on host, :default_action => 'gem_install'


    if fact('osfamily') == 'Suse'
      if fact('operatingsystem') == 'OpenSuSE'
        install_package host, 'ruby-devel augeas-devel libxml2-devel'
        on host, "#{gem_proxy} gem install ruby-augeas --no-ri --no-rdoc"
      end
    end

  end

  # Copy over some files
  if fact('osfamily') == 'Debian'
    scp_to(host, "#{files_dir}/logstash_#{LS_VERSION}_all.deb", '/tmp/')
  end

  if fact('osfamily') == 'RedHat'
    scp_to(host, "#{files_dir}/logstash-#{LS_VERSION}.noarch.rpm", '/tmp/')
  end

  if fact('osfamily') == 'Suse'
    scp_to(host, "#{files_dir}/logstash-#{LS_VERSION}.noarch.rpm", '/tmp/')
  end


  # on debian/ubuntu nodes ensure we get the latest info
  # Can happen we have stalled data in the images
  if fact('osfamily') == 'Debian'
    on host, "apt-get update"
  end

end

RSpec.configure do |c|

  project_root = File.dirname(File.dirname(__FILE__))

  # Readable test descriptions
  c.formatter = :documentation
  c.color = true

  # declare an exclusion filter
  c.filter_run_excluding :broken => true

  c.before :suite do

    # Provide all the Puppet modules we need to the test instance.
    Dir.glob('spec/fixtures/modules/*').each do |path|
      name = File.basename(path)
      path = project_root if name == 'logstash' # Otherwise, all we get is a useless symlink.
      puppet_module_install(:source => path, :module_name => name)
    end

    # if fact('osfamily') == 'Suse'
    #   on host, puppet('module','install','darin-zypprepo'), { :acceptable_exit_codes => [0,1] }
    # end
  end
end

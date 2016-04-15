require 'beaker-rspec'
require 'net/http'
require 'pry'
require 'securerandom'

files_dir = './spec/fixtures/artifacts'

# Collect global options from the environment.
if ENV['BEAKER_ls_version'].nil?
  raise 'Please set the BEAKER_ls_version environment variable.'
end
LS_VERSION = ENV['BEAKER_ls_version']
REPO_VERSION = LS_VERSION[0..(LS_VERSION.rindex('.') - 1)] # "1.5.3-1" -> "1.5"

# Package naming is not super-consistent for early versions, so we
# need to explicitly provide URLs for the ones that we can't construct
# correctly with simple string manipulation.
def logstash_package_url
  url_root = 'http://download.elasticsearch.org/logstash/logstash/packages'
  url_map = {
    '1.4.5' => {
      'deb' => "#{url_root}/debian/logstash_1.4.5-1-a2bacae_all.deb",
      'rpm' => "#{url_root}/centos/logstash-1.4.5-1_a2bacae.noarch.rpm"
    }
  }

  case fact('osfamily')
  when 'Debian'
    package_format = 'deb'
  when 'RedHat', 'Suse'
    package_format = 'rpm'
  end

  if url_map[LS_VERSION].nil? || url_map[LS_VERSION][package_format].nil?
    url = "#{url_root}/debian/logstash_#{LS_VERSION}-1_all.deb" if package_format == 'deb'
    url = "#{url_root}/centos/logstash-#{LS_VERSION}-1.noarch.rpm" if package_format == 'rpm'
  else
    url = url_map[LS_VERSION][package_format]
  end
  url
end

def logstash_package_filename
  File.basename(logstash_package_url)
end

hosts.each do |host|
  # Install Puppet
  if host.is_pe?
    on host, "hostname #{host.name}"
    install_pe
  else
    install_puppet_on(host, version: '3.0.0')
  end

  if fact('osfamily') == 'Suse'
    if fact('operatingsystem') == 'OpenSuSE'
      install_package host, 'ruby-devel augeas-devel libxml2-devel'
      on host, 'gem install ruby-augeas --no-ri --no-rdoc'
    end
  end

  # Update package cache for those who need it.
  on host, 'apt-get update' if fact('osfamily') == 'Debian'

  # Aquire binary packages of Logstash for various operating systems.
  download = "#{files_dir}/#{logstash_package_filename}"
  File.write(download, Net::HTTP.get(URI(logstash_package_url))) unless File.exist?(download)
  scp_to(host, download, '/tmp/')
end

RSpec.configure do |c|
  project_root = File.dirname(File.dirname(__FILE__))

  # Readable test descriptions
  c.formatter = :documentation
  c.color = true

  # declare an exclusion filter
  c.filter_run_excluding broken: true

  c.before :suite do
    # Provide all the Puppet modules we need to the test instance.
    Dir.glob('spec/fixtures/modules/*').each do |path|
      name = File.basename(path)
      path = project_root if name == 'logstash' # Otherwise, all we get is a useless symlink.
      puppet_module_install(source: path, module_name: name)
    end

    # if fact('osfamily') == 'Suse'
    #   on host, puppet('module','install','darin-zypprepo'), { :acceptable_exit_codes => [0,1] }
    # end
  end
end

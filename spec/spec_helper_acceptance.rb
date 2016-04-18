require 'beaker-rspec'
require 'net/http'
require 'pry'
require 'securerandom'

files_dir = './spec/fixtures/artifacts'

# Collect global options from the environment.
if ENV['LOGSTASH_VERSION'].nil?
  raise 'Please set the LOGSTASH_VERSION environment variable.'
end
LS_VERSION = ENV['LOGSTASH_VERSION']

PUPPET_VERSION = ENV['PUPPET_VERSION'] || '3.8.6'
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
    install_puppet_on(host, version: PUPPET_VERSION)
  end

  if fact('osfamily') == 'Suse'
    if fact('operatingsystem') == 'OpenSuSE'
      install_package host, 'ruby-devel augeas-devel libxml2-devel'
      on host, 'gem install ruby-augeas --no-ri --no-rdoc'
    end
  end

  # Update package cache for those who need it.
  on host, 'apt-get update' if fact('osfamily') == 'Debian'

  # Aquire a binary package of Logstash.
  on host, "wget #{logstash_package_url} -O /tmp/#{logstash_package_filename}"

  project_root = File.dirname(File.dirname(__FILE__))
  install_dev_puppet_module_on(host, source: project_root, module_name: 'logstash')
  install_puppet_module_via_pmt_on(host, module_name: 'puppetlabs-stdlib')
  install_puppet_module_via_pmt_on(host, module_name: 'puppetlabs-apt')
  install_puppet_module_via_pmt_on(host, module_name: 'electrical-file_concat')
  install_puppet_module_via_pmt_on(host, module_name: 'darin-zypprepo')
end

RSpec.configure do |c|

  # Readable test descriptions
  c.formatter = :documentation
  c.color = true

  # declare an exclusion filter
  c.filter_run_excluding broken: true
end

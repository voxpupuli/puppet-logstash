require 'beaker-rspec'
require 'net/http'
require 'pry'
require 'securerandom'

# Collect global options from the environment.
if ENV['LOGSTASH_VERSION'].nil?
  raise 'Please set the LOGSTASH_VERSION environment variable.'
end
LS_VERSION = ENV['LOGSTASH_VERSION']
PUPPET_VERSION = ENV['PUPPET_VERSION'] || '3.8.6'

PE_VERSION = ENV['BEAKER_PE_VER'] || ENV['PE_VERSION'] || '3.8.3'
PE_DIR = ENV['BEAKER_PE_DIR']

REPO_VERSION = LS_VERSION[0..(LS_VERSION.rindex('.') - 1)] # "1.5.3-1" -> "1.5"

def apply_manifest_fixture(manifest_name)
  manifest = File.read("./spec/fixtures/manifests/#{manifest_name}.pp")
  apply_manifest(manifest, catch_failures: true)
end

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

# Provided a basic Logstash install. Useful as a testing pre-requisite.
def install_logstash
  apply_manifest_fixture('install_logstash')
end

def stop_logstash
  apply_manifest_fixture('stop_logstash')
  shell('ps -eo comm | grep java | xargs kill -9')
end

def pe_package_url
  distro, distro_version = ENV['BEAKER_set'].split('-')
  case distro
  when 'debian'
    os = 'debian'
    arch = 'amd64'
  when 'centos'
    os = 'el'
    arch = 'x86_64'
  when 'ubuntu'
    os = 'ubuntu'
    arch = 'amd64'
  end
  url_root = "https://s3.amazonaws.com/pe-builds/released/#{PE_VERSION}"
  url = "#{url_root}/puppet-enterprise-#{PE_VERSION}-#{os}-#{distro_version}-#{arch}.tar.gz"
end

def pe_package_filename
  File.basename(pe_package_url)
end

def puppet_enterprise?
  ENV['BEAKER_IS_PE'] == 'true' || ENV['IS_PE'] == 'true'
end

hosts.each do |host|
  # Install Puppet
  if puppet_enterprise?
    pe_download = File.join(PE_DIR, pe_package_filename)
    `curl -s -o #{pe_download} #{pe_package_url}` unless File.exist?(pe_download)
    on host, "hostname #{host.name}"
    install_pe_on(host, pe_ver: PE_VERSION)
  else
    begin
      install_puppet_on(host, version: PUPPET_VERSION)
    rescue
      install_puppet_from_gem_on(host, version: PUPPET_VERSION)
    end
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

  # Provide a Logstash plugin as a local Gem.
  scp_to(host, './spec/fixtures/plugins/logstash-output-cowsay-0.1.0.gem', '/tmp/')

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

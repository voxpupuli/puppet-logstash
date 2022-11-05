# frozen_string_literal: true

require 'beaker-rspec'
require 'net/http'
require 'securerandom'
require 'yaml'

# Collect global options from the environment.
LS_VERSION = ENV['LOGSTASH_VERSION'] || '7.17.7'
PUPPET_VERSION = ENV['PUPPET_VERSION'] || '4.10.7'

PE_VERSION = ENV['BEAKER_PE_VER'] || ENV['PE_VERSION'] || '3.8.3'
PE_DIR = ENV['BEAKER_PE_DIR']

IS_PRERELEASE = if LS_VERSION =~ %r{(alpha|beta|rc)}
                  true
                else
                  false
                end

def agent_version_for_puppet_version(puppet_version)
  # REF: https://docs.puppet.com/puppet/latest/reference/about_agent.html
  version_map = {
    # Puppet => Agent
    '4.9.4' => '1.9.3',
    '4.8.2' => '1.8.3',
    '4.8.1' => '1.8.2',
    '4.8.0' => '1.8.0',
    '4.7.1' => '1.7.2',
    '4.7.0' => '1.7.1',
    '4.6.2' => '1.6.2',
    '4.6.1' => '1.6.1',
    '4.6.0' => '1.6.0',
    '4.5.3' => '1.5.3',
    '4.4.2' => '1.4.2',
    '4.4.1' => '1.4.1',
    '4.4.0' => '1.4.0',
    '4.3.2' => '1.3.6',
    '4.3.1' => '1.3.2',
    '4.3.0' => '1.3.0',
    '4.2.3' => '1.2.7',
    '4.2.2' => '1.2.6',
    '4.2.1' => '1.2.2',
    '4.2.0' => '1.2.1',
    '4.1.0' => '1.1.1',
    '4.0.0' => '1.0.1'
  }
  version_map[puppet_version]
end

def apply_manifest_fixture(manifest_name)
  manifest = File.read("./spec/fixtures/manifests/#{manifest_name}.pp")
  apply_manifest(manifest, catch_failures: true)
end

def expect_no_change_from_manifest(manifest)
  expect(apply_manifest(manifest).exit_code).to eq(0)
end

def http_package_url
  url_root = "https://artifacts.elastic.co/downloads/logstash/logstash-#{LS_VERSION}"

  case fact('osfamily')
  when 'Debian'
    "#{url_root}-amd64.deb"
  when 'RedHat', 'Suse'
    "#{url_root}-x86_64.rpm"
  end
end

def local_file_package_url
  "file:///tmp/#{logstash_package_filename}"
end

def puppet_fileserver_package_url
  "puppet:///modules/logstash/#{logstash_package_filename}"
end

def logstash_package_filename
  File.basename(http_package_url)
end

def logstash_package_version
  package_version = if LS_VERSION =~ %r{(alpha|beta|rc)}
                      LS_VERSION.gsub('-', '~')
                    else
                      LS_VERSION
                    end

  case fact('osfamily') # FIXME: Put this logic in the module, not the tests.
  when 'RedHat'
    "#{package_version}-1"
  when 'Debian', 'Suse'
    "1:#{package_version}-1"
  end
end

def logstash_config_manifest
  <<-END
  logstash::configfile { 'basic_config':
    content => 'input { tcp { port => 2000 } } output { null {} }'
  }
  END
end

def install_logstash_manifest(extra_args = nil)
  <<-END
  class { 'elastic_stack::repo':
    version    => #{LS_VERSION[0]},
    prerelease => #{IS_PRERELEASE},
  }
  class { 'logstash':
    manage_repo  => true,
    version      => '#{logstash_package_version}',
    #{extra_args}
  }

  #{logstash_config_manifest}
  END
end

def include_logstash_manifest
  <<-END
  class { 'elastic_stack::repo':
    version    => #{LS_VERSION[0]},
    prerelease => #{IS_PRERELEASE},
  }

  include logstash

  #{logstash_config_manifest}
  END
end

def install_logstash_from_url_manifest(url, extra_args = nil)
  <<-END
  class { 'logstash':
    package_url  => '#{url}',
    #{extra_args}
  }

  #{logstash_config_manifest}
  END
end

def install_logstash_from_local_file_manifest(extra_args = nil)
  install_logstash_from_url_manifest(local_file_package_url, extra_args)
end

def remove_logstash_manifest
  "class { 'logstash': ensure => 'absent' }"
end

def stop_logstash_manifest
  "class { 'logstash': status => 'disabled' }"
end

# Provide a basic Logstash install. Useful as a testing pre-requisite.
def install_logstash(extra_args = nil)
  result = apply_manifest(install_logstash_manifest(extra_args), catch_failures: true)
  sleep 5 # FIXME: This is horrible.
  result
end

def include_logstash
  result = apply_manifest(include_logstash_manifest, catch_failures: true)
  sleep 5 # FIXME: This is horrible.
  result
end

def install_logstash_from_url(url, extra_args = nil)
  manifest = install_logstash_from_url_manifest(url, extra_args)
  result = apply_manifest(manifest, catch_failures: true)
  sleep 5 # FIXME: This is horrible.
  result
end

def install_logstash_from_local_file(extra_args = nil)
  install_logstash_from_url(local_file_package_url, extra_args)
end

def remove_logstash
  result = apply_manifest(remove_logstash_manifest)
  sleep 5 # FIXME: This is horrible.
  result
end

def stop_logstash
  result = apply_manifest(stop_logstash_manifest, catch_failures: true)
  shell('ps -eo comm | grep java | xargs kill -9', accept_all_exit_codes: true)
  sleep 5 # FIXME: This is horrible.
  result
end

def logstash_process_list
  ps_cmd = 'ps -ww --no-headers -C java -o user,command | grep logstash'
  shell(ps_cmd, accept_all_exit_codes: true).stdout.split("\n")
end

def logstash_settings
  YAML.safe_load(shell('cat /etc/logstash/logstash.yml').stdout)
end

def expect_setting(setting, value)
  expect(logstash_settings[setting]).to eq(value)
end

def pipelines_from_yaml
  YAML.safe_load(shell('cat /etc/logstash/pipelines.yml').stdout)
end

def service_restart_message
  "Service[logstash]: Triggered 'refresh'"
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
  "#{url_root}/puppet-enterprise-#{PE_VERSION}-#{os}-#{distro_version}-#{arch}.tar.gz"
end

def pe_package_filename
  File.basename(pe_package_url)
end

def puppet_enterprise?
  ENV['BEAKER_IS_PE'] == 'true' || ENV['IS_PE'] == 'true'
end

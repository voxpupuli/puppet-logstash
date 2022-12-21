# frozen_string_literal: true

require 'yaml'

# Collect global options from the environment.
LS_VERSION = ENV['LOGSTASH_VERSION'] || '7.17.7'
IS_PRERELEASE = if LS_VERSION =~ %r{(alpha|beta|rc)}
                  true
                else
                  false
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

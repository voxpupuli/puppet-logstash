# This mangages the system service for Logstash.
#
# It is usually used only by the top-level `logstash` class. It's unlikely
# that you will need to declare this class yourself.
#
# @example Include this class to ensure its resources are available.
#   include logstash::service
#
# @author https://github.com/elastic/puppet-logstash/graphs/contributors
#
class logstash::service {
  $default_settings = {
    'path.data'   => '/var/lib/logstash',
    'path.config' => '/etc/logstash/conf.d',
    'path.logs'   => '/var/log/logstash',
  }

  $default_startup_options = {
    'LS_HOME'             => $logstash::home_dir,
    'LS_SETTINGS_DIR'     => $logstash::config_dir,
    'LS_OPTS'             => "--path.settings=${logstash::config_dir}",
    'LS_JAVA_OPTS'        => '""',
    'LS_PIDFILE'          => '/var/run/logstash.pid',
    'LS_USER'             => $logstash::logstash_user,
    'LS_GROUP'            => $logstash::logstash_group,
    'LS_GC_LOG_FILE'      => '/var/log/logstash/gc.log',
    'LS_OPEN_FILES'       => '16384',
    'LS_NICE'             => '19',
    'SERVICE_NAME'        => '"logstash"',
    'SERVICE_DESCRIPTION' => '"logstash"',
  }

  $settings = $default_settings + $logstash::settings
  $startup_options = $default_startup_options + $logstash::startup_options
  $jvm_options = $logstash::jvm_options
  $jvm_options_defaults = $logstash::jvm_options_defaults
  $pipelines = $logstash::pipelines

  File {
    owner  => $logstash::config_user,
    group  => $logstash::config_group,
    mode   => '0640',
    notify => Exec['logstash-system-install'],
  }

  if $logstash::ensure == 'present' {
    case $logstash::status {
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }
      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }
      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }
      default: {
        fail("\"${logstash::status}\" is an unknown service status value")
      }
    }
  } else {
    $service_ensure = 'stopped'
    $service_enable = false
  }

  if $service_ensure == 'running' {
    # Then make sure the Logstash startup options are up to date.
    file { '/etc/logstash/startup.options':
      content => template('logstash/startup.options.erb'),
    }

    # ..and make sure the JVM options are up to date.
    file { '/etc/logstash/jvm.options':
      content => template('logstash/jvm.options.erb'),
    }

    # ..and pipelines.yml, if the user provided such. If they didn't, zero out
    # the file, which will default Logstash to traditional single-pipeline
    # behaviour.
    if(empty($pipelines)) {
      file { '/etc/logstash/pipelines.yml':
        content => '',
      }
    }
    else {
      file { '/etc/logstash/pipelines.yml':
        content => template('logstash/pipelines.yml.erb'),
      }
    }

    # ..and the Logstash internal settings too.
    file { '/etc/logstash/logstash.yml':
      content => template('logstash/logstash.yml.erb'),
    }

    # Invoke 'system-install', which generates startup scripts based on the
    # contents of the 'startup.options' file.
    # Only if restart_on_change is not false
    if $logstash::restart_on_change {
      exec { 'logstash-system-install':
        command     => "${logstash::home_dir}/bin/system-install",
        refreshonly => true,
        notify      => Service['logstash'],
      }
    } else {
      exec { 'logstash-system-install':
        command     => "${logstash::home_dir}/bin/system-install",
        refreshonly => true,
      }
    }
  }

  service { 'logstash':
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
    provider   => $logstash::service_provider,
  }

  # If any files tagged as config files for the service are changed, notify
  # the service so it restarts.
  if $logstash::restart_on_change {
    File<| tag == 'logstash_config' |> ~> Service['logstash']
    Logstash::Plugin<| |> ~> Service['logstash']
  }
}

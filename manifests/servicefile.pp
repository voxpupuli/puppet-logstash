# == Define: logstash::servicefile
#
#  Define to write the config file.
#
#
#
# === Parameters
#
#
#
#
#
# === Examples
#
#  logstash::servicefile { 'agent':
#  }
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::servicefile (
  $service_ensure,
  $service_enable
) {

  require logstash::params

  if ! member($logstash::instances, $name) {
    fail("${name} is not a valid instances value.")
  }

  # If we are managing the init script
  if $logstash::status != 'unmanaged' {

    if $logstash::initfiles {
      $init = $logstash::initfiles
      $initfile = $init[$name]
    }

    if $logstash::defaultsfiles {
      $def = $logstash::defaultsfiles
      $defaults_file = $def[$name]
    }

    $installpath = $logstash::params::installpath
    $configdir = "${logstash::params::configdir}/${name}/conf"

    # Do we get a custom init script?
    if $initfile != undef {

      # Set initscript to undef
      $initscript = undef
    }

    # If we are using a custom provider, thus not using the package and not supplying a custom init script use our own init script
    if $logstash::provider == 'custom' and $initfile == undef {

      ## Get the init file we provide
      case $::operatingsystem {
        'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon': {
          $initscript = template("${module_name}/etc/init.d/logstash.init.RedHat.erb")
        }
        'Debian', 'Ubuntu': {
          $initscript = template("${module_name}/etc/init.d/logstash.init.Debian.erb")
        }
        default: {
          fail("\"${module_name}\" provides no default init file
                for \"${::operatingsystem}\"")
        }

      }
    }

    # Write service file
    file { "/etc/init.d/logstash-${name}":
      ensure  => present,
      content => $initscript,
      source  => $initfile,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      before  => Service[ "logstash-${name}" ]
    }

    if $defaults_file {
      # Write defaults file if we have one
      file { "${logstash::params::defaults_location}/logstash-${name}":
        ensure => present,
        source => $defaults_file,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        before => Service[ "logstash-${name}" ]
      }
    }

    service { "logstash-${name}":
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => "logstash-${name}",
      hasstatus  => $logstash::params::service_hasstatus,
      hasrestart => $logstash::params::service_hasrestart,
      pattern    => "logstash-${name}"
    }

  }

}

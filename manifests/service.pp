# == Class: logstash::service
#
# This class exists to coordinate all service management related actions,
# functionality and logical units in a central place.
#
# <b>Note:</b> "service" is the Puppet term and type for background processes
# in general and is used in a platform-independent way. E.g. "service" means
# "daemon" in relation to Unix-like systems.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'logstash::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class logstash::service {

  #### Service management

  # set params: in operation
  if $logstash::ensure == 'present' {

    case $logstash::status {
      # make sure service is currently running, start it on boot
      'enabled': {
        $service_ensure = 'running'
        $service_enable = true
      }
      # make sure service is currently stopped, do not start it on boot
      'disabled': {
        $service_ensure = 'stopped'
        $service_enable = false
      }
      # make sure service is currently running, do not start it on boot
      'running': {
        $service_ensure = 'running'
        $service_enable = false
      }
      # do not start service on boot, do not care whether currently running or not
      'unmanaged': {
        $service_ensure = undef
        $service_enable = false
      }
      # unknown status
      # note: don't forget to update the parameter check in init.pp if you
      #       add a new or change an existing status.
      default: {
        fail("\"${logstash::status}\" is an unknown service status value")
      }
    }

  # set params: removal
  } else {

    # make sure the service is stopped and disabled (the removal itself will be
    # done by package.pp)
    $service_ensure = 'stopped'
    $service_enable = false

  }

  # If we are managing the init script
  if $logstash::status != 'unmanaged' {

    File {
      owner => 'root',
      group => 'root',
      mode  => '0644'
    }

    # Do we get a custom init script?
    if $logstash::initfile != undef {

      # Set initscript to undef
      $initscript = undef
    }

    # If we are using a custom provider, thus not using the package and not supplying a custom init script use our own init script
    if $logstash::provider == 'custom' and $logstash::initfile == undef {

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

    if $logstash::initfile != undef or $initscript != '' {

      file { '/etc/init.d/logstash':
        ensure  => present,
        mode    => '0755',
        content => $initscript,         # undef when using an external source, otherwise content of our own init script
        source  => $logstash::initfile, # undef when using content of our own init script, otherwise it contains the source of the external init script
      }
    }
  }

  # If we supply a defaults file, place it.
  if $logstash::defaultsfile != undef {

    file { "${logstash::params::defaults_location}/logstash":
      ensure => present,
      source => $logstash::defaultsfile,
    }

  }


  # Only not managed the init file when we are using an external jar file and use an other service manager
  # TODO: This is an ugly hack for now because i can't think up a better solution.
  if ($logstash::jarfile != undef and $logstash::status == 'unmanaged') {
    # Don't manage the service
  } else {

    service { 'logstash':
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $logstash::params::service_name,
      hasstatus  => $logstash::params::service_hasstatus,
      hasrestart => $logstash::params::service_hasrestart,
      pattern    => $logstash::params::service_pattern,
    }

  }

}

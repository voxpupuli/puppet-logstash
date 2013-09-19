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

  if $logstash::multi_instance == true {

    if $logstash::provider == 'package' {

      service { 'logstash':
        ensure => 'stopped',
        enable => false
      }

    }

  } else {

    if $logstash::defaultsfiles {

      # Write defaults file if we have one
      file { "${logstash::params::defaults_location}/logstash":
        ensure => present,
        source => $logstash::defaultsfiles,
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        before => Service[ 'logstash' ],
        notify => Service[ 'logstash' ],
      }

    } else {

      if $logstash::provider == 'custom' {

        file { "${logstash::params::defaults_location}/logstash":
          ensure => present,
          source => "puppet:///modules/${module_name}/etc/sysconfig/logstash.defaults",
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          before => Service[ 'logstash' ],
          notify => Service[ 'logstash' ]
        }

      }

    }

    if $logstash::initfiles {

      # Write service file
      file { '/etc/init.d/logstash':
        ensure => present,
        source => $logstash::initfiles,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        before => Service[ 'logstash' ]
      }

    } else {

      if $logstash::provider == 'custom' {

        $instance_name = ''
        $configdir = "${logstash::configdir}/conf.d"

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

        # Place built in init file
        file { '/etc/init.d/logstash':
          ensure  => present,
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          content => $initscript,
          before  => Service[ 'logstash' ]
        }
      }

    }

  }

  # Only not managed the init file when we are using an external jar file and use an other service manager
  # TODO: This is an ugly hack for now because i can't think up a better solution.
  if ($logstash::jarfile != undef and $logstash::status == 'unmanaged') {
    # Don't manage the service
  } else {

    if $logstash::multi_instance == true {

      # Setup and manage instances
      logstash::servicefile { $logstash::instances:
        service_enable => $service_enable,
        service_ensure => $service_ensure
      }

    } else {

      # Use the single instance
      service { 'logstash':
        ensure => $service_ensure,
        enable => $service_enable
      }

    }
  }

}

# == Class: logstash::params
#
# This class exists to
# 1. Declutter the default value assignment for class parameters.
# 2. Manage internally used module variables in a central place.
#
# Therefore, many operating system dependent differences (names, paths, ...)
# are addressed in here.
#
#
# === Parameters
#
# This class does not provide any parameters.
#
#
# === Examples
#
# This class is not intended to be used directly.
#
#
# === Links
#
# * {Puppet Docs: Using Parameterized Classes}[http://j.mp/nVpyWY]
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class logstash::params {

  #### Default values for the parameters of the main module class, init.pp


  # ensure
  $ensure = 'present'

  # autoupgrade
  $autoupgrade = false

  # service status
  $status = 'enabled'


  #### Defaults for other files

  # Config directory
  $configdir = '/etc/logstash'

  # Logging dir
  $logdir = '/var/log/logstash/'

  # File user/group
  $logstash_user  = 'root'
  $logstash_group = 'root'

  #### Internal module values

  # packages
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon': {
      # main application
      $package     = [ 'logstash' ]
      $installpath = '/usr/share/logstash'
    }
    'Debian', 'Ubuntu': {
      # main application
      $package     = [ 'logstash' ]
      $installpath = '/var/lib/logstash'
    }
    default: {
      fail("\"${module_name}\" provides no package default value
            for \"${::operatingsystem}\"")
    }
  }

  # service parameters
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon': {
      $service_name       = 'logstash'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
      $defaults_location  = '/etc/sysconfig'
    }
    'Debian', 'Ubuntu': {
      $service_name       = 'logstash'
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
      $defaults_location  = '/etc/default'
    }
    default: {
      fail("\"${module_name}\" provides no service parameters
            for \"${::operatingsystem}\"")
    }
  }

}

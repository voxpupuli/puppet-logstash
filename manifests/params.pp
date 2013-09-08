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

  # jarfile
  $jarfile_master = 'https://logstash.objects.dreamhost.com/release/logstash-1.2.1-flatjar.jar'

  case $::osfamily {
    'Darwin': {
      $jarfile = $jarfile_master
    }
    default: {
      $jarfile = undef
    }
  }


  # provider
  case $::osfamily {
    'Darwin': {
      $provider = 'custom'
    }
    default: {
      $provider = 'package'
    }
  }

  #### Defaults for other files

  # Config directory

  case $::osfamily {
    'Linux': {
      $configdir = '/etc/logstash'
    }
    'Darwin': {
      $configdir = '/Library/Application Support/Logstash'
    }
  }

  # Logging dir

  case $::osfamily {
    'Linux': {
      $logdir = '/var/log/logstash/'
    }
    'Darwin': {
      $logdir = '/Library/Logs/logstash'
    }
  }
  # File user/group
  $logstash_user  = 'root'
  case $::osfamily {
    'Linux': {
      $logstash_group = 'root'
    }
    'Darwin': {
      $logstash_group = 'wheel'
    }
  }

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
    'Darwin': {
      $installpath = '/Library/Logstash'
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
      $service_base_name  = "${service_name}-"
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
      $defaults_location  = '/etc/sysconfig'
    }
    'Debian', 'Ubuntu': {
      $service_name       = 'logstash'
      $service_base_name  = "${service_name}-"
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
      $defaults_location  = '/etc/default'
    }
    'Darwin': {
      $service_name       = 'net.logstash'
      $service_base_name  = "${service_name}."
      $service_hasrestart = true
      $service_hasstatus  = true
      $service_pattern    = $service_name
      $defaults_location  = '/Library/Application Support/Logstash'
    }
    default: {
      fail("\"${module_name}\" provides no service parameters
            for \"${::operatingsystem}\"")
    }
  }

  # Download tool

  case $::osfamily {
    'Linux': {
      $download_tool = 'wget'
    }
    'Darwin': {
      $download_tool = 'curl'
    }
  }

}

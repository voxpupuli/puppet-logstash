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
  $service_enable,
  $service_ensure = undef
) {

  require logstash::params

  if ! member($logstash::instances, $name) {
    fail("${name} is not a valid instances value.")
  }

    case $::osfamily {
    'Linux': {
      $init_script_path = "/etc/init.d/logstash-${name}"
      $init_name = "logstash-${name}"
      $init_owner = 'root'
      $init_group = 'root'
      $init_mode = '0755'
    }
    'Darwin': {
      $init_script_path = "/Library/LaunchDaemons/org.logstash.${name}.plist"
      $init_name = "org.logstash.${name}"
      $init_owner = 'root'
      $init_group = 'admin'
      $init_mode = '0744'
    }
  }



  if $logstash::ensure == 'present' {

    # If we are managing the init script
    if $logstash::status != 'unmanaged' {

      if $logstash::initfiles {
        $init = $logstash::initfiles
        $initfile = $init[$name]
      }

      if $logstash::defaultsfiles {
        $def = $logstash::defaultsfiles
        $def_file = $def[$name]
      }

      $configdir = "${logstash::configdir}/${name}/config"

      # Do we get a custom init script?
      if $initfile != undef {

        # Set initscript to undef
        $initscript = undef
      }

      # If we are using a custom provider, thus not using the package and not supplying a custom init script use our own init script
      if $initfile == undef {

        ## Get the init file we provide
        case $::operatingsystem {
          'RedHat', 'CentOS', 'Fedora', 'Scientific', 'Amazon': {
            $initscript = template("${module_name}/etc/init.d/logstash.init.RedHat.erb")
          }
          'Debian', 'Ubuntu': {
            $initscript = template("${module_name}/etc/init.d/logstash.init.Debian.erb")
          }
          'Darwin': {
            $initscript = template("${module_name}/Library/LaunchDaemons/org.logstash.plist.erb")
          }
          default: {
            fail("\"${module_name}\" provides no default init file
                  for \"${::operatingsystem}\"")
          }

        }
      }

      # If no custom defaults file is provided, lets use our default one
      if $def_file {
        $defaults_file = $def_file
        if $::operatingsystem == 'Darwin' {
          fail('A custom settings file is not supported on OSX')
        }
      } else {
        $defaults_file = "puppet:///modules/${module_name}/etc/sysconfig/logstash.defaults"
      }

      # Write service file
      file { $init_script_path:
        ensure  => $logstash::ensure,
        content => $initscript,
        source  => $initfile,
        owner   => $init_owner,
        group   => $init_group,
        mode    => $init_mode,
        before  => Service[ $init_name ]
      }

      if $::operatingsystem == 'Darwin' {
        exec { "/bin/launchctl load -w ${init_script_path}":
          subscribe => File[$init_script_path],
          refreshonly => true
        }
      }

      case $::osfamily {
        'Linux': {
          if $defaults_file {
            # Write defaults file if we have one
            file { "${logstash::params::defaults_location}/logstash-${name}":
              ensure => $logstash::ensure,
              source => $defaults_file,
              owner  => 'root',
              group  => 'root',
              mode   => '0644',
              before => Service[ $init_name ],
              notify => Service[ $init_name ],
            }
          }
        }
      }
    }
  }

  if $logstash::status != 'unmanaged' {

    service { $init_name:
      ensure     => $service_ensure,
      enable     => $service_enable,
      name       => $init_name,
      hasstatus  => $logstash::params::service_hasstatus,
      hasrestart => $logstash::params::service_hasrestart,
      pattern    => $init_name
    }

  }

}

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

        $instance_name = $name
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

      # If no custom defaults file is provided, lets use our default one
      if $def_file {
        $defaults_file = $def_file
      } else {
        $defaults_file = "puppet:///modules/${module_name}/etc/sysconfig/logstash.defaults"
      }

      # Write service file
      file { "/etc/init.d/logstash-${name}":
        ensure  => $logstash::ensure,
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
          ensure => $logstash::ensure,
          source => $defaults_file,
          owner  => 'root',
          group  => 'root',
          mode   => '0644',
          before => Service[ "logstash-${name}" ],
          notify => Service[ "logstash-${name}" ],
        }
      }
    }
  }

  if $logstash::status != 'unmanaged' {

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

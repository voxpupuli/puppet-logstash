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
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class logstash::service {
  require ::java

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
      # do not start service on boot, do not care whether currently running
      # or not
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

  if ( $logstash::status != 'unmanaged' ) {
    # defaults file content. Either from a hash or file
    if ($logstash::init_defaults_file != undef) {
      $defaults_content = undef
      $defaults_source  = $logstash::init_defaults_file
    } elsif ($logstash::init_defaults != undef and is_hash($logstash::init_defaults) ) {
      $defaults_content = template("${module_name}/etc/sysconfig/defaults.erb")
      $defaults_source  = undef
    } else {
      $defaults_content = undef
      $defaults_source  = undef
    }

    # Check if we are going to manage the defaults file.
    if ( $defaults_content != undef or $defaults_source != undef ) {
      file { "${logstash::params::defaults_location}/${name}":
        ensure  => $logstash::ensure,
        source  => $defaults_source,
        content => $defaults_content,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        tag     => ['logstash_config'],
      }
    }
  }

  service { 'logstash':
    ensure     => $service_ensure,
    enable     => $service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  # If any files tagged as config files for the service are changed, notify
  # the service so it restarts.
  if $::logstash::restart_on_change {
    File<| tag == 'logstash_config' |> ~> Service['logstash']
    Logstash::Plugin<| |> ~> Service['logstash']
  }
}

# == Define: logstash::service::openbsd
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
# ===== service_flags
# String, used on OpenBSD to override/set the service flags, defaults to undef.
#
#
# === Examples
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
define logstash::service::openbsd (
  $service_flags = undef,
){

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

  $notify_service = $logstash::restart_on_change ? {
    true  => Service[$name],
    false => undef,
  }


  if ( $logstash::status != 'unmanaged' ) {

    # init file from template
    if ($logstash::init_template != undef) {

      file { "/etc/rc.d/${name}":
        ensure  => $logstash::ensure,
        content => template($logstash::init_template),
        owner   => 'root',
        group   => '0',
        mode    => '0555',
        before  => Service[$name],
        notify  => $notify_service
      }

    }

  }

  # action
  service { $name:
    ensure     => $service_ensure,
    enable     => $service_enable,
    name       => $name,
    flags      => $service_flags,
    hasstatus  => $logstash::params::service_hasstatus,
    hasrestart => $logstash::params::service_hasrestart,
  }

}

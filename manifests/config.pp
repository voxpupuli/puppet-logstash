# == Class: logstash::config
#
# This class exists to coordinate all configuration related actions,
# functionality and logical units in a central place.
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
#   class { 'logstash::config': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class logstash::config {

  #### Configuration

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  $notify_service = $logstash::restart_on_change ? {
    true  => Class['logstash::service'],
    false => undef,
  }

  if ( $logstash::ensure == 'present' ) {

    $patterns_dir = "${logstash::configdir}/patterns"
    $plugins_dir = "${logstash::configdir}/plugins"

    file { $logstash::configdir:
      ensure  => directory,
      purge   => $logstash::purge_configdir,
      recurse => $logstash::purge_configdir
    }

    file { "${logstash::configdir}/conf.d":
      ensure  => directory,
      require => File[$logstash::configdir]
    }

    file_concat { 'ls-config':
      ensure  => 'present',
      tag     => "LS_CONFIG_${::fqdn}",
      path    => "${logstash::configdir}/conf.d/logstash.conf",
      owner   => $logstash::logstash_user,
      group   => $logstash::logstash_group,
      mode    => '0644',
      notify  => $notify_service,
      require => File[ "${logstash::configdir}/conf.d" ]
    }

    # Load any Hiera based configuration settings (if enabled and present)
    #
    # NOTE: hiera hash merging does not work in a parameterized class
    #   definition; so we call it here.
    #
    # http://docs.puppetlabs.com/hiera/1/puppet.html#limitations
    # https://tickets.puppetlabs.com/browse/HI-118
    #
    if $::logstash::hieramerge {
      $x_configs = hiera_hash('logstash::configs', $::logstash::configs)

    # Fall back to user given class parameter / priority based hiera lookup
    } else {
      $x_configs = $::logstash::configs
    }

    if $x_configs {
      create_resources('::logstash::configfile', $x_configs)
    }

    file { $patterns_dir:
      ensure  => directory,
      require => File[$logstash::configdir]
    }

    file { [
      $plugins_dir,
      "${plugins_dir}/logstash",
      "${plugins_dir}/logstash/inputs",
      "${plugins_dir}/logstash/outputs",
      "${plugins_dir}/logstash/filters",
      "${plugins_dir}/logstash/codecs"
    ]:
      ensure  => directory,
      require => File[$logstash::configdir]
    }


  } elsif ( $logstash::ensure == 'absent' ) {

    file { $logstash::configdir:
      ensure  => 'absent',
      recurse => true,
      force   => true
    }

  }

}

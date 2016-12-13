# This class provides various pre-requisites for configuring Logstash.
#
# @example Include this class to ensure its resources are available.
#   include logstash::config
#
# @author https://github.com/elastic/puppet-logstash/graphs/contributors
#
class logstash::config {
  require logstash::package

  File {
    owner  => $logstash::logstash_user,
    group => $logstash::logstash_group,
  }

  $notify_service = $logstash::restart_on_change ? {
    true  => Class['logstash::service'],
    false => undef,
  }

  if ( $logstash::ensure == 'present' ) {
    file { $logstash::configdir:
      ensure  => directory,
      purge   => $logstash::purge_configdir,
      recurse => $logstash::purge_configdir,
    }

    file { "${logstash::configdir}/conf.d":
      ensure  => directory,
      require => File[$logstash::configdir],
    }

    $directories = [
      "${logstash::configdir}/patterns",
      "${logstash::configdir}/plugins",
      "${logstash::configdir}/plugins/logstash",
      "${logstash::configdir}/plugins/logstash/inputs",
      "${logstash::configdir}/plugins/logstash/outputs",
      "${logstash::configdir}/plugins/logstash/filters",
      "${logstash::configdir}/plugins/logstash/codecs",
    ]

    file { $directories:,
      ensure => directory,
    }
  }
  elsif ( $logstash::ensure == 'absent' ) {
    file { $logstash::configdir:
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }
  }
}

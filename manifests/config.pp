# == Class: logstash::config
#
# FIXME/TODO Please check if you want to remove this class because it may be
#            unnecessary for your module. Don't forget to update the class
#            declarations and relationships at init.pp afterwards (the relevant
#            parts are marked with "FIXME/TODO" comments).
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

  file { 'logstash_config':
    ensure  => 'present',
    path    => '/etc/logstash/logstash.conf',
    mode    => '0644',
    content => template('logstash/config.erb'),
    notify  => $notify_service,
  }

}

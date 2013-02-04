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
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class logstash::config {

  #### Configuration

  exec { 'create_config_dir':
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${logstash::params::configdir}",
    creates => $logstash::params::configdir;
  }

  ### Manage the config directory
  file { $logstash::params::configdir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => true,
    recurse => true,
    require => Exec['create_config_dir']
  }

}

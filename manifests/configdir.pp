# == Define: logstash::confdir
#
#
#
# === Parameters
#
#
#
# === Examples
#
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::configdir {

  require logstash::params

  $config_dir = "${logstash::params::configdir}/${name}/config"

  #### Create the directory
  exec { "create_config_dir_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${config_dir}",
    creates => $config_dir;
  }

  ### Manage the config directory
  file { $config_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => true,
    recurse => true,
    require => Exec["create_config_dir_${name}"],
    notify  => Service["logstash-${name}"]
  }

  $sincedb_dir = "${logstash::params::configdir}/${name}/sincedb"

  #### Create the directory
  exec { "create_sincedb_dir_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${sincedb_dir}",
    creates => $sincedb_dir;
  }

}

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

  #### Create the config dir directory
  $config_dir = "${logstash::params::configdir}/${name}/config"

  exec { "create_config_dir_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${config_dir}",
    creates => $config_dir;
  }

  #### Manage the config directory
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

  #### Create the sincedb directory

  $sincedb_dir = "${logstash::params::configdir}/${name}/sincedb"

  exec { "create_sincedb_dir_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${sincedb_dir}",
    creates => $sincedb_dir;
  }

  #### Create the tmp dir

  $tmp_dir = "${logstash::params::configdir}/${name}/tmp"

  exec { "create_tmp_dir_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${tmp_dir}",
    creates => $tmp_dir;
  }
}

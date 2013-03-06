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
define logstash::confdir {

  require logstash::params

  $dir = "${logstash::params::configdir}/${name}.d"

  #### Create the directory
  exec { "create_config_dir_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${dir}",
    creates => $dir;
  }

  ### Manage the config directory
  file { $dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    purge   => true,
    recurse => true,
    require => Exec["create_config_dir_${name}"]
  }

}

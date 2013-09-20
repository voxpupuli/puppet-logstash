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

  $config_dir  = "${logstash::configdir}/${name}/config"
  $sincedb_dir = "${logstash::configdir}/${name}/sincedb"

  if $logstash::ensure == 'present' {

    File {
      owner => $logstash::logstash_user,
      group => $logstash::logstash_group
    }

    #### Create the config dir directory
    exec { "create_config_dir_${name}":
      cwd     => '/',
      path    => ['/usr/bin', '/bin'],
      command => "mkdir -p ${config_dir}",
      creates => $config_dir;
    }

    #### Manage the config directory
    file { $config_dir:
      ensure  => directory,
      mode    => '0440',
      purge   => true,
      recurse => true,
      require => Exec["create_config_dir_${name}"],
      notify  => Service["logstash-${name}"];
    }

    #### Create the sincedb directory
    exec { "create_sincedb_dir_${name}":
      cwd     => '/',
      path    => ['/usr/bin', '/bin'],
      command => "mkdir -p ${sincedb_dir}",
      creates => $sincedb_dir;
    }

    file { $sincedb_dir:
      ensure  => directory,
      mode    => '0640',
      require => Exec["create_sincedb_dir_${name}"];
    }

    if is_hash($logstash::conffile) and has_key($logstash::conffile, $name ) {
      file { "${config_dir}/logstash.config":
        ensure  => file,
        mode    => '0440',
        source  => $logstash::conffile[$name],
      }
    }

  } else {
    #### If logstash::ensure != present, purge config and sincedb directory
    file { $config_dir :
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }

    file { $sincedb_dir :
      ensure  => 'absent',
      recurse => true,
      force   => true,
    }

  }
}

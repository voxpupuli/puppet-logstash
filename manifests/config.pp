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

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    # Setup and manage config dirs for the instances
    logstash::configdir { $logstash::instances:; }

  } else {

    # Manage the single config dir
    file { "${logstash::configdir}/conf.d":
      ensure  => directory,
      mode    => '0640',
      purge   => true,
      recurse => true,
      notify  => Service['logstash']
    }

    if $logstash::conffile {
      file { "${logstash::configdir}/conf.d/logstash.config":
        ensure  => file,
        mode    => '0440',
        source  => $logstash::conffile,
      }
    }
  }

  $tmp_dir = "${logstash::installpath}/tmp"

  #### Create the tmp dir
  exec { 'create_tmp_dir':
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${tmp_dir}",
    creates => $tmp_dir;
  }

  file { $tmp_dir:
    ensure  => directory,
    mode    => '0640',
    require => Exec[ 'create_tmp_dir' ]
  }

}

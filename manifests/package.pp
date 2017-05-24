# == Class: logstash::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
#
#
# === Parameters
#
# [*package_configfiles*]
#   Whether to keep or replace modified config files when installing or upgrading a package.
#   This only affects the apt and dpkg providers. Defaults to keep.
#   Valid values are keep, replace.
#
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'logstash::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class logstash::package(
  $package_configfiles = 'keep',
){

  Exec {
    path      => [ '/bin', '/usr/bin', '/usr/local/bin' ],
    cwd       => '/',
    tries     => 3,
    try_sleep => 10,
  }

  #### Package management

  # set params: in operation
  if $logstash::ensure == 'present' {

    # action
    if ($logstash::package_url != undef) {

      $package_dir = $logstash::package_dir

      # Create directory to place the package file
      exec { 'create_package_dir_logstash':
        cwd     => '/',
        path    => ['/usr/bin', '/bin'],
        command => "mkdir -p ${logstash::package_dir}",
        creates => $logstash::package_dir;
      }

      file { $package_dir:
        ensure  => 'directory',
        purge   => $logstash::purge_package_dir,
        force   => $logstash::purge_package_dir,
        backup  => false,
        require => Exec['create_package_dir_logstash'],
      }

    }

  } else { # Package removal
    $package_dir = $logstash::package_dir

    file { $package_dir:
      ensure => 'absent',
      purge  => true,
      force  => true,
      backup => false,
    }

  }

  #class { 'logstash::package::core': }
  logstash::package::install { 'logstash':
    package_url         => $logstash::package_url,
    version             => $logstash::version,
    package_name        => $logstash::package_name,
    package_configfiles => $package_configfiles,
  }
}

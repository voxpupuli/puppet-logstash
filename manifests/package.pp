# == Class: logstash::package
#
# This class exists to coordinate all software package management related
# actions, functionality and logical units in a central place.
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
#   class { 'logstash::package': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class logstash::package {

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  #### Package management

  # set params: in operation
  if $logstash::ensure == 'present' {

    # Check if we want to install a specific version or not
    if $logstash::version == false {

      $package_ensure = $logstash::autoupgrade ? {
        true  => 'latest',
        false => 'present',
      }

    } else {

      # install specific version
      $package_ensure = $logstash::version

    }

  # set params: removal
  } else {
    $package_ensure = 'purged'
  }

  if ($logstash::provider == 'package') {
    # action
    package { $logstash::params::package:
      ensure => $package_ensure,
    }
  } elsif ($logstash::provider == 'custom') {

    $jarfile_arr = split($logstash::jarfile, '/')
    $jarfile_arr2 = reverse($jarfile_arr)
    $jarfile = $jarfile_arr2[0]

    exec { 'create_dir':
      cwd     => '/',
      path    => ['/usr/bin', '/bin'],
      command => "mkdir -p ${logstash::installpath}";
    }

    exec { 'create_log_dir':
      cwd     => '/',
      path    => ['/usr/bin', '/bin'],
      command => 'mkdir -p /var/log/logstash';
    }

    file { "${logstash::installpath}/logstash.jar":
      ensure  => present,
      source  => $logstash::jarfile,
      require => Exec['create_dir']
    }

    file { '/etc/init.d/logstash':
      ensure => present,
      source => $logstash::initfile,
      mode   => '0755'
    }
  }

}

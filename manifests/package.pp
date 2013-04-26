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
    # We are using a package provided by a repository
    package { $logstash::params::package:
      ensure => $package_ensure,
    }

  } elsif ($logstash::provider == 'custom') {
    if $logstash::ensure == 'present' {

      # We are using an external provided jar file
      if $logstash::jarfile == undef {
        fail('logstash needs jarfile argument when using custom provider')
      }

      if $logstash::installpath == undef {
        fail('logstash need installpath argument when using custom provider')
      }

      # Create directory to place the jar file
      exec { 'create_install_dir':
        cwd     => '/',
        path    => ['/usr/bin', '/bin'],
        command => "mkdir -p ${logstash::installpath}",
        creates => $logstash::installpath;
      }

      # Create log directory
      exec { 'create_log_dir':
        cwd     => '/',
        path    => ['/usr/bin', '/bin'],
        command => "mkdir -p ${logstash::params::logdir}",
        creates => $logstash::params::logdir;
      }

      # Place the jar file
      $filenameArray = split($logstash::jarfile, '/')
      $basefilename = $filenameArray[-1]

      file { "${logstash::installpath}/${basefilename}":
        ensure  => present,
        source  => $logstash::jarfile,
        require => Exec['create_install_dir'],
        backup  => false
      }

      # Create symlink
      file { "${logstash::installpath}/logstash.jar":
        ensure  => 'link',
        target  => "${logstash::installpath}/${basefilename}",
        require => File["${logstash::installpath}/${basefilename}"],
        backup  => false
      }

    } else {
      ## Do we need to do anything when removing ?
    }

  }
}

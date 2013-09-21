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

      $jardir = "${logstash::installpath}/jars"

      # Create directory to place the jar file
      exec { 'create_install_dir':
        cwd     => '/',
        path    => ['/usr/bin', '/bin'],
        command => "mkdir -p ${logstash::installpath}",
        creates => $logstash::installpath;
      }

      # Purge old jar files
      file { $jardir:
        ensure  => 'directory',
        purge   => $logstash::purge_jars,
        force   => $logstash::purge_jars,
        require => Exec['create_install_dir'],
      }

      # Create log directory
      exec { 'create_log_dir':
        cwd     => '/',
        path    => ['/usr/bin', '/bin'],
        command => "mkdir -p ${logstash::params::logdir}",
        creates => $logstash::params::logdir;
      }

      file { $logstash::params::logdir:
        ensure  => 'directory',
        owner   => $logstash::logstash_user,
        group   => $logstash::logstash_group,
        require => Exec['create_log_dir'],
      }

      # Place the jar file
      $filenameArray = split($logstash::jarfile, '/')
      $basefilename = $filenameArray[-1]

      $sourceArray = split($logstash::jarfile, ':')
      $protocol_type = $sourceArray[0]

      case $protocol_type {
        puppet: {

          file { "${jardir}/${basefilename}":
            ensure  => present,
            source  => $logstash::jarfile,
            require => File[$jardir],
            backup  => false,
          }

          File["${jardir}/${basefilename}"] -> File["${logstash::installpath}/logstash.jar"]

        }
        ftp, https, http: {

          exec { 'download-logstash':
            command => "wget -O ${jardir}/${basefilename} ${logstash::jarfile} 2> /dev/null",
            path    => ['/usr/bin', '/bin'],
            creates => "${jardir}/${basefilename}",
            require => File[$jardir],
          }

          Exec['download-logstash'] -> File["${logstash::installpath}/logstash.jar"]

        }
        default: {
          fail('Protocol must be puppet, http, https, or ftp.')
        }
      }

      # Create symlink
      file { "${logstash::installpath}/logstash.jar":
        ensure  => 'link',
        target  => "${jardir}/${basefilename}",
        backup  => false
      }

    } else {

      # If not present, remove installpath, leave logfiles
      file { $logstash::installpath:
        ensure  => 'absent',
        force   => true,
        recurse => true,
        purge   => true,
      }
    }

  }
}

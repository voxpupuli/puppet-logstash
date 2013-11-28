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
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class logstash::package {


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

    if ($logstash::software_provider == 'package') {

    # action
    if ($logstash::software_url != undef) {

      $software_dl_dir = $logstash::software_dl_dir

      # Create directory to place the package file
      exec { 'create_software_dl_dir':
        cwd     => '/',
        path    => ['/usr/bin', '/bin'],
        command => "mkdir -p ${logstash::software_dl_dir}",
        creates => $logstash::software_dl_dir;
      }

      file { $software_dl_dir:
        ensure  => 'directory',
        purge   => $logstash::purge_software_dl_dir,
        force   => $logstash::purge_software_dl_dir,
        require => Exec['create_software_dl_dir'],
      }

      $filenameArray = split($logstash::software_url, '/')
      $basefilename = $filenameArray[-1]

      $sourceArray = split($logstash::software_url, ':')
      $protocol_type = $sourceArray[0]

      $extArray = split($basefilename, '\.')
      $ext = $extArray[-1]

      case $protocol_type {

        puppet: {

          file { "${software_dl_dir}/${basefilename}":
            ensure  => present,
            source  => $logstash::software_url,
            require => File[$software_dl_dir],
            backup  => false,
            before  => Package[$logstash::params::package]
          }

        }
        ftp, https, http: {

          exec { 'download-package':
            command => "${logstash::params::dlcmd} ${software_dl_dir}/${basefilename} ${logstash::software_url} 2> /dev/null",
            path    => ['/usr/bin', '/bin'],
            creates => "${software_dl_dir}/${basefilename}",
            timeout => $logstash::software_dl_timeout,
            require => File[$software_dl_dir],
            before  => Package[$logstash::params::package]
          }

        }
        file: {

          $source_path = $sourceArray[1]
          file { "${software_dl_dir}/${basefilename}":
            ensure  => present,
            source  => $source_path,
            require => File[$software_dl_dir],
            backup  => false,
            before  => Package[$logstash::params::package]
          }

        }
        default: {
          fail("Protocol must be puppet, file, http, https, or ftp. You have given \"${protocol_type}\"")
        }
      }

      case $ext {
        'deb':   { $pkg_provider = 'dpkg' }
        'rpm':   { $pkg_provider = 'rpm'  }
        default: { fail("Unknown file extention \"${ext}\".") }
      }

      $pkg_source = "${software_dl_dir}/${basefilename}"

    } else {
      $pkg_source = undef
      $pkg_provider = undef
    }

  # Package removal
  } else {

    $pkg_source = undef
    $pkg_provider = undef
    $package_ensure = 'purged'
  }

  package { $logstash::params::package:
    ensure   => $package_ensure,
    source   => $pkg_source,
    provider => $pkg_provider
  }

  } elsif ($logstash::software_provider == 'jar') {


  } else {
    fail("\"${logstash::software_provider}\" is not supported")
  }
}

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

    # action
    if ($logstash::package_url != undef) {

      case $logstash::software_provider {
        'package': { $before = Package[$logstash::params::package]  }
        default:   { fail("software provider \"${logstash::software_provider}\".") }
      }

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
        require => Exec['create_package_dir_logstash'],
      }

      $filenameArray = split($logstash::package_url, '/')
      $basefilename = $filenameArray[-1]

      $sourceArray = split($logstash::package_url, ':')
      $protocol_type = $sourceArray[0]

      $extArray = split($basefilename, '\.')
      $ext = $extArray[-1]

      $pkg_source = "${package_dir}/${basefilename}"

      case $protocol_type {

        puppet: {

          file { $pkg_source:
            ensure  => present,
            source  => $logstash::package_url,
            require => File[$package_dir],
            backup  => false,
            before  => $before
          }

        }
        ftp, https, http: {

          exec { 'download_package_logstash':
            command => "${logstash::params::download_tool} ${pkg_source} ${logstash::package_url} 2> /dev/null",
            path    => ['/usr/bin', '/bin'],
            creates => $pkg_source,
            timeout => $logstash::package_dl_timeout,
            require => File[$package_dir],
            before  => $before
          }

        }
        file: {

          $source_path = $sourceArray[1]
          file { $pkg_source:
            ensure  => present,
            source  => $source_path,
            require => File[$package_dir],
            backup  => false,
            before  => $before
          }

        }
        default: {
          fail("Protocol must be puppet, file, http, https, or ftp. You have given \"${protocol_type}\"")
        }
      }

      if ($logstash::software_provider == 'package') {

        case $ext {
          'deb':   { $pkg_provider = 'dpkg'  }
          'rpm':   { $pkg_provider = 'rpm'   }
          default: { fail("Unknown file extention \"${ext}\".") }
        }

      }

    } else {
      $pkg_source = undef
      $pkg_provider = undef
    }

  } else { # Package removal
    $pkg_source = undef
    $pkg_provider = undef
    $package_ensure = 'purged'
  }


  if ($logstash::software_provider == 'package') {

    package { $logstash::params::package:
      ensure   => $package_ensure,
      source   => $pkg_source,
      provider => $pkg_provider
    }

  } else {
    fail("\"${logstash::software_provider}\" is not supported")
  }

}

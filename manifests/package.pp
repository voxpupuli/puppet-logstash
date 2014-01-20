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
    if ($logstash::software_url != undef) {

      case $logstash::software_provider {
        'package': { $before = Package[$logstash::params::package]  }
        default:   { fail("software provider \"${logstash::software_provider}\".") }
      }

      $software_dir = $logstash::software_dir

      # Create directory to place the package file
      exec { 'create_software_dir':
        cwd     => '/',
        path    => ['/usr/bin', '/bin'],
        command => "mkdir -p ${logstash::software_dir}",
        creates => $logstash::software_dir;
      }

      file { $software_dir:
        ensure  => 'directory',
        purge   => $logstash::purge_software_dir,
        force   => $logstash::purge_software_dir,
        require => Exec['create_software_dir'],
      }

      $filenameArray = split($logstash::software_url, '/')
      $basefilename = $filenameArray[-1]

      $sourceArray = split($logstash::software_url, ':')
      $protocol_type = $sourceArray[0]

      $extArray = split($basefilename, '\.')
      $ext = $extArray[-1]

      $sw_source = "${software_dir}/${basefilename}"

      case $protocol_type {

        puppet: {

          file { $sw_source:
            ensure  => present,
            source  => $logstash::software_url,
            require => File[$software_dir],
            backup  => false,
            before  => $before
          }

        }
        ftp, https, http: {

          exec { 'download-package':
            command => "${logstash::params::download_tool} ${software_dir}/${basefilename} ${logstash::software_url} 2> /dev/null",
            path    => ['/usr/bin', '/bin'],
            creates => $sw_source,
            timeout => $logstash::software_dl_timeout,
            require => File[$software_dir],
            before  => $before
          }

        }
        file: {

          $source_path = $sourceArray[1]
          file { $sw_source:
            ensure  => present,
            source  => $source_path,
            require => File[$software_dir],
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
      $sw_source = undef
      $pkg_provider = undef
    }

  } else { # Package removal
    $sw_source = undef
    $pkg_provider = undef
    $package_ensure = 'purged'
  }


  if ($logstash::software_provider == 'package') {

    package { $logstash::params::package:
      ensure   => $package_ensure,
      source   => $sw_source,
      provider => $pkg_provider
    }

  } else {
    fail("\"${logstash::software_provider}\" is not supported")
  }

}

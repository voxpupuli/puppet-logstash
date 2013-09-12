# == Class: logstash::java
#
# This class exists to install java if its not managed from an other module
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
#   class { 'logstash::java': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
class logstash::java {
  case $::osfamily {
    'Linux': {
      if $logstash::java_package == undef {
        # Default Java package
        case $::operatingsystem {
          'CentOS', 'Fedora', 'Scientific', 'RedHat', 'Amazon': {
            $package = 'java-1.6.0-openjdk'
          }
          'Debian', 'Ubuntu': {
            $package = 'openjdk-6-jre-headless'
          }
          default: {
            fail("\"${module_name}\" provides no java package
                  for \"${::operatingsystem}\"")
          }
        }
      } else {
        $package = $logstash::java_package
      }

      ## Install the java package unless already specified somewhere else
      if !defined(Package[$package]) {
        package { $package:
          ensure => present
        }
      }
    }
    'Darwin': {
      if $logstash::java_package != undef {
        fail("Darwin not support installing java from a package")
      }
      exec { 'download-apple-java':
        command => "curl -L -o /tmp/java.dmg http://support.apple.com/downloads/DL1572/en_US/JavaForOSX2013-004.dmg 2> /dev/null",
        path    => ['/usr/bin', '/bin'],
        creates => "/tmp/java.dmg"
      }
      package {'apple-java':
        provider => 'pkgdmg',
        ensure   => present,
        source   => '/tmp/java.dmg',
        require  => Exec['download-apple-java']
      }
    }
  }
}

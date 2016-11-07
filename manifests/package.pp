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
  logstash::package::install { 'logstash':
    package_url  => $logstash::package_url,
    version      => $logstash::version,
    package_name => $logstash::package_name,
  }



}

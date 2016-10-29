# == Class: logstash::service
#
# This class exists to coordinate all service management related actions,
# functionality and logical units in a central place.
#
# <b>Note:</b> "service" is the Puppet term and type for background processes
# in general and is used in a platform-independent way. E.g. "service" means
# "daemon" in relation to Unix-like systems.
#
#
# === Parameters
#
# ===== service_flags
# String, used on OpenBSD to override/set the service flags, defaults to undef.
#
# === Examples
#
# This class may be imported by other classes to use its functionality:
#   class { 'logstash::service': }
#
# It is not intended to be used directly by external resources like node
# definitions or other modules.
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
class logstash::service (
  $service_flags = undef,
){

  case $logstash::service_provider {

    'init': {
      logstash::service::init { $logstash::params::service_name: }
    }
    'openbsd': {
      logstash::service::openbsd { $logstash::params::service_name:
        service_flags => $service_flags,
      }
    }

    default: {
      fail("Unknown service provider ${logstash::service_provider}")
    }

  }

}

# == Define: logstash::filter::generic
#
#  Generic Output Module to allow for custom code within config
#
#  This allow for passing a string containing custom logic and for
#  adding conditionals to filter config
#
# === Parameters
#
# [*config*]
#   String containing everything within the filter { } block
#   Value type is string
#   This variable is required
#
# [*instances*]
#   Array of instance names to which this define is.
#   Value type is array
#   Default value: [ 'array' ]
#   This variable is optional
#
# === Extra information
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
# * Adam Boeglin <mailto:adamrb@gmail.com>
#
define logstash::filter::generic (
  $config,
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_generic_${name}")
    $services     = prefix($instances, 'logstash-')

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_generic_${name}"
    $services  = 'logstash'

  }

  #### Validate parameters

  validate_array($instances)

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n $config \n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

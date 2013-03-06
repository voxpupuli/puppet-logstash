# == Define: logstash::servicefile
#
#  Define to write the config file.
#
#
#
# === Parameters
#
#
#
#
#
# === Examples
#
#  logstash::servicefile { 'agent':
#  }
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::servicefile (
  $service_ensure,
  $service_enable
) {

  require logstash::params

  if ! member($logstash::instances, $name) {
    fail("${name} is not a valid instances value.")
  }

  $def = $logstash::defaults
  $defaults_file = $def[$name]

  $installpath = $logstash::params::installpath

  case $::operatingsystem {
    'RedHat', 'CentOS', 'Fedora', 'Scientific': {
      $initscript = template("${module_name}/etc/init.d/logstash.init.RedHat.erb")
    }
    'Debian', 'Ubuntu': {
      $initscript = template("${module_name}/etc/init.d/logstash.init.Debian.erb")
    }
    default: {
      fail("\"${module_name}\" provides no default init file
          for \"${::operatingsystem}\"")
    }
  }

  # Write defaults file
  file { "${logstash::params::defaults_location}/${name}":
    ensure => present,
    source => $defaults_file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Write service file
  file { "/etc/init.d/logstash-${name}":
    ensure  => present,
    content => $initscript,
    owner   => 'root',
    group   => 'root',
    mode    => '0755'
  }

  service { "logstash-${name}":
    ensure     => $service_ensure,
    enable     => $service_enable,
    name       => "logstash-${name}",
    hasstatus  => $logstash::params::service_hasstatus,
    hasrestart => $logstash::params::service_hasrestart,
    pattern    => "logstash-${name}",
    require    => [ File["/etc/init.d/logstash-${name}"], File["${logstash::params::defaults_location}/${name}"] ]
  }
}

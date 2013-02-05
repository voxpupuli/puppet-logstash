# == Define: logstash::cfgfile
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
#  logstash::cfgfile { 'agent':
#    file    => 'input_file_apache',
#    content => "content for the plugin"
#  }
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::cfgfile (
  $file,
  $content
) {

  require logstash::params

  validate_string($file)
  validate_string($content)

  if ! member($logstash::instances, $name) {
    fail("${name} is not a valid instances value.")
  }

  file { "${logstash::params::configdir}/${name}.d/${file}":
    ensure  => present,
    content => $content,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

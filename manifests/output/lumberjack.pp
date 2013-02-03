# == Define: logstash::output::lumberjack
#
#
#
# === Parameters
#
# [*exclude_tags*]
#   Only handle events without any of these tags. Note this check is
#   additional to type and tags.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*fields*]
#   Only handle events with all of these fields. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*hosts*]
#   list of addresses lumberjack can send to
#   Value type is array
#   Default value: None
#   This variable is required
#
# [*port*]
#   the port to connect to
#   Value type is number
#   Default value: None
#   This variable is required
#
# [*ssl_certificate*]
#   ssl certificate to use
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*type*]
#   The type to act on. If a type is given, then this output will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*window_size*]
#   window size
#   Value type is number
#   Default value: 5000
#   This variable is optional
#
#
#
# === Examples
#
#
#
#
# === Extra information
#
#  This define is created based on LogStash version 1.1.9
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.9/outputs/lumberjack
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::lumberjack (
  $ssl_certificate,
  $port,
  $hosts,
  $exclude_tags    = '',
  $fields          = '',
  $tags            = '',
  $type            = '',
  $window_size     = ''
) {


  require logstash::params

  #### Validate parameters
  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $hosts {
    validate_array($hosts)
    $arr_hosts = join($hosts, '\', \'')
    $opt_hosts = "  hosts => ['${arr_hosts}']\n"
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if $window_size {
    if ! is_numeric($window_size) {
      fail("\"${window_size}\" is not a valid window_size parameter value")
    } else {
      $opt_window_size = "  window_size => ${window_size}\n"
    }
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $ssl_certificate {
    validate_string($ssl_certificate)
    $opt_ssl_certificate = "  ssl_certificate => \"${ssl_certificate}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_lumberjack_${name}":
    ensure  => present,
    content => "output {\n lumberjack {\n${opt_exclude_tags}${opt_fields}${opt_hosts}${opt_port}${opt_ssl_certificate}${opt_tags}${opt_type}${opt_window_size} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

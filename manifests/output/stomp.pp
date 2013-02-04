# == Define: logstash::output::stomp
#
#
#
# === Parameters
#
# [*debug*]
#   Enable debugging output?
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*destination*]
#   The destination to read events from. Supports string expansion,
#   meaning %{foo} values will expand to the field value.  Example:
#   "/topic/logstash"
#   Value type is string
#   Default value: None
#   This variable is required
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
# [*host*]
#   The address of the STOMP server.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*password*]
#   The password to authenticate with.
#   Value type is password
#   Default value: ""
#   This variable is optional
#
# [*port*]
#   The port to connect to on your STOMP server.
#   Value type is number
#   Default value: 61613
#   This variable is optional
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
# [*user*]
#   The username to authenticate with.
#   Value type is string
#   Default value: ""
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
#  http://logstash.net/docs/1.1.9/outputs/stomp
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::stomp (
  $destination,
  $host,
  $password     = '',
  $fields       = '',
  $debug        = '',
  $exclude_tags = '',
  $port         = '',
  $tags         = '',
  $type         = '',
  $user         = ''
) {


  require logstash::params

  #### Validate parameters
  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if $password {
    validate_string($password)
    $opt_password = "  password => \"${password}\"\n"
  }

  if $host {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $destination {
    validate_string($destination)
    $opt_destination = "  destination => \"${destination}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $user {
    validate_string($user)
    $opt_user = "  user => \"${user}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_stomp_${name}":
    ensure  => present,
    content => "output {\n stomp {\n${opt_debug}${opt_destination}${opt_exclude_tags}${opt_fields}${opt_host}${opt_password}${opt_port}${opt_tags}${opt_type}${opt_user} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

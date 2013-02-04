# == Define: logstash::output::juggernaut
#
#   Push messages to the juggernaut websockets server:
#   https://github.com/maccman/juggernaut Wraps Websockets and supports
#   other methods (including xhr longpolling) This is basically, just an
#   extension of the redis output (Juggernaut pulls messages from redis).
#   But it pushes messages to a particular channel and formats the
#   messages in the way juggernaut expects.
#
#
# === Parameters
#
# [*channels*]
#   List of channels to which to publish. Dynamic names are valid here,
#   for example "logstash-%{@type}".
#   Value type is array
#   Default value: None
#   This variable is required
#
# [*db*]
#   The redis database number.
#   Value type is number
#   Default value: 0
#   This variable is optional
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
#   The hostname of the redis server to which juggernaut is listening.
#   Value type is string
#   Default value: "127.0.0.1"
#   This variable is optional
#
# [*message_format*]
#   How should the message be formatted before pushing to the websocket.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*password*]
#   Password to authenticate with.  There is no authentication by default.
#   Value type is password
#   Default value: None
#   This variable is optional
#
# [*port*]
#   The port to connect on.
#   Value type is number
#   Default value: 6379
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*timeout*]
#   Redis initial connection timeout in seconds.
#   Value type is number
#   Default value: 5
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
#  http://logstash.net/docs/1.1.9/outputs/juggernaut
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::juggernaut (
  $channels,
  $message_format = '',
  $exclude_tags   = '',
  $fields         = '',
  $host           = '',
  $db             = '',
  $password       = '',
  $port           = '',
  $tags           = '',
  $timeout        = '',
  $type           = ''
) {


  require logstash::params

  #### Validate parameters
  if $channels {
    validate_array($channels)
    $arr_channels = join($channels, '\', \'')
    $opt_channels = "  channels => ['${arr_channels}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

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

  if $timeout {
    if ! is_numeric($timeout) {
      fail("\"${timeout}\" is not a valid timeout parameter value")
    } else {
      $opt_timeout = "  timeout => ${timeout}\n"
    }
  }

  if $db {
    if ! is_numeric($db) {
      fail("\"${db}\" is not a valid db parameter value")
    } else {
      $opt_db = "  db => ${db}\n"
    }
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

  if $message_format {
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $host {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_juggernaut_${name}":
    ensure  => present,
    content => "output {\n juggernaut {\n${opt_channels}${opt_db}${opt_exclude_tags}${opt_fields}${opt_host}${opt_message_format}${opt_password}${opt_port}${opt_tags}${opt_timeout}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

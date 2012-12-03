# == Define: logstash::input::irc
#
#   Read events from an IRC Server.
#
#
# === Parameters
#
# [*add_field*] 
#   Add a field to an event
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*channels*] 
#   Channels to listen to
#   Value type is array
#   Default value: None
#   This variable is required
#
# [*debug*] 
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*format*] 
#   The format of input data (plain, json, json_event)
#   Value can be any of: "plain", "json", "json_event"
#   Default value: None
#   This variable is optional
#
# [*host*] 
#   Host of the IRC Server to connect to.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*message_format*] 
#   If format is "json", an event sprintf string to build what the display
#   @message should be given (defaults to the raw JSON). sprintf format
#   strings look like %{fieldname} or %{@metadata}.  If format is
#   "json_event", ALL fields except for @type are expected to be present.
#   Not receiving all fields will cause unexpected results.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*nick*] 
#   IRC Nickname
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*password*] 
#   IRC Server password
#   Value type is password
#   Default value: nil
#   This variable is optional
#
# [*port*] 
#   Port for the IRC Server
#   Value type is number
#   Default value: None
#   This variable is required
#
# [*real*] 
#   IRC Real name
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*tags*] 
#   Add any number of arbitrary tags to your event.  This can help with
#   processing later.
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*type*] 
#   Label this input with a type. Types are used mainly for filter
#   activation.  If you create an input with type "foobar", then only
#   filters which also have type "foobar" will act on them.  The type is
#   also stored as part of the event itself, so you can also use the type
#   to search for in the web interface.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*user*] 
#   IRC Username
#   Value type is string
#   Default value: "logstash"
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
#  This define is created based on LogStash version 1.1.5
#  Extra information about this input can be found at:
#  http://logstash.net/docs/1.1.5/inputs/irc
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::irc(
  $channels,
  $type,
  $port,
  $host,
  $nick           = '',
  $message_format = '',
  $format         = '',
  $password       = '',
  $debug          = '',
  $real           = '',
  $tags           = '',
  $add_field      = '',
  $user           = '',
) {

  require logstash::params

  #### Validate parameters
  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $channels {
    validate_array($channels)
    $arr_channels = join($channels, "', '")
    $opt_channels = "  channels => ['${arr_channels}']\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $add_field {
    validate_hash($add_field)
    $arr_add_field = inline_template('<%= add_field.to_a.flatten.inspect %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    }
  }

  if $format {
    if ! ($format in ['plain', 'json', 'json_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if $password { 
    validate_string($password)
    $opt_password = "  password => \"${password}\"\n"
  }

  if $nick { 
    validate_string($nick)
    $opt_nick = "  nick => \"${nick}\"\n"
  }

  if $message_format { 
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $real { 
    validate_string($real)
    $opt_real = "  real => \"${real}\"\n"
  }

  if $host { 
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
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

  file { "${logstash::params::configdir}/input_irc_${name}":
    ensure  => present,
    content => "input {\n irc {\n${opt_add_field}${opt_channels}${opt_debug}${opt_format}${opt_host}${opt_message_format}${opt_nick}${opt_password}${opt_port}${opt_real}${opt_tags}${opt_type}${opt_user} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

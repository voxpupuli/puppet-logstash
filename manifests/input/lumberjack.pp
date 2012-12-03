# == Define: logstash::input::lumberjack
#
#   Receive events using the lumberjack protocol.  This is mainly to
#   receive events shipped  with lumberjack,
#   http://github.com/jordansissel/lumberjack
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
#   the address to listen on.
#   Value type is string
#   Default value: "0.0.0.0"
#   This variable is optional
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
# [*port*] 
#   the port to listen on.
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
# [*ssl_key*] 
#   ssl key to use
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*ssl_key_passphrase*] 
#   ssl key passphrase to use
#   Value type is password
#   Default value: None
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
#  http://logstash.net/docs/1.1.5/inputs/lumberjack
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::lumberjack(
  $type,
  $ssl_key,
  $ssl_certificate,
  $port,
  $message_format     = '',
  $host               = '',
  $format             = '',
  $debug              = '',
  $ssl_key_passphrase = '',
  $tags               = '',
  $add_field          = '',
) {

  require logstash::params

  #### Validate parameters
  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
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

  if $ssl_key_passphrase { 
    validate_string($ssl_key_passphrase)
    $opt_ssl_key_passphrase = "  ssl_key_passphrase => \"${ssl_key_passphrase}\"\n"
  }

  if $ssl_key { 
    validate_string($ssl_key)
    $opt_ssl_key = "  ssl_key => \"${ssl_key}\"\n"
  }

  if $ssl_certificate { 
    validate_string($ssl_certificate)
    $opt_ssl_certificate = "  ssl_certificate => \"${ssl_certificate}\"\n"
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

  file { "${logstash::params::configdir}/input_lumberjack_${name}":
    ensure  => present,
    content => "input {\n lumberjack {\n${opt_add_field}${opt_debug}${opt_format}${opt_host}${opt_message_format}${opt_port}${opt_ssl_certificate}${opt_ssl_key}${opt_ssl_key_passphrase}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

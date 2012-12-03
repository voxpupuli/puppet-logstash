# == Define: logstash::input::zenoss
#
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
# [*exchange*] 
#   The name of the exchange to bind the queue. This is analogous to the
#   'amqp output' config 'name'
#   Value type is string
#   Default value: "zenoss.zenevents"
#   This variable is optional
#
# [*format*] 
#   The format of input data (plain, json, json_event)
#   Value can be any of: "plain", "json", "json_event"
#   Default value: None
#   This variable is optional
#
# [*host*] 
#   Your amqp server address
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*key*] 
#   The routing key to use. This is only valid for direct or fanout
#   exchanges  Routing keys are ignored on topic exchanges. Wildcards are
#   not valid on direct exchanges.
#   Value type is string
#   Default value: "zenoss.zenevent.#"
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
# [*password*] 
#   Your amqp password
#   Value type is password
#   Default value: "zenoss"
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
#   Your amqp username
#   Value type is string
#   Default value: "zenoss"
#   This variable is optional
#
# [*vhost*] 
#   The vhost to use. If you don't know what this is, leave the default.
#   Value type is string
#   Default value: "/zenoss"
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
#  http://logstash.net/docs/1.1.5/inputs/zenoss
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::zenoss(
  $type,
  $message_format = '',
  $exchange       = '',
  $format         = '',
  $host           = '',
  $key            = '',
  $debug          = '',
  $password       = '',
  $tags           = '',
  $add_field      = '',
  $user           = '',
  $vhost          = '',
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

  if $message_format { 
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $key { 
    validate_string($key)
    $opt_key = "  key => \"${key}\"\n"
  }

  if $host { 
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $exchange { 
    validate_string($exchange)
    $opt_exchange = "  exchange => \"${exchange}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $user { 
    validate_string($user)
    $opt_user = "  user => \"${user}\"\n"
  }

  if $vhost { 
    validate_string($vhost)
    $opt_vhost = "  vhost => \"${vhost}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/input_zenoss_${name}":
    ensure  => present,
    content => "input {\n zenoss {\n${opt_add_field}${opt_debug}${opt_exchange}${opt_format}${opt_host}${opt_key}${opt_message_format}${opt_password}${opt_tags}${opt_type}${opt_user}${opt_vhost} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

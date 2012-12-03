# == Define: logstash::input::xmpp
#
#   This input allows you to receive events over XMPP/Jabber.  This plugin
#   can be used for accepting events from humans or applications XMPP, or
#   you can use it for PubSub or general message passing for logstash to
#   logstash.
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
#   Set to true to enable greater debugging in XMPP. Useful for debugging
#   network/authentication erros.
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
#   The xmpp server to connect to. This is optional. If you omit this
#   setting, the host on the user/identity is used. (foo.com for
#   user@foo.com)
#   Value type is string
#   Default value: None
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
#   The xmpp password for the user/identity.
#   Value type is password
#   Default value: None
#   This variable is required
#
# [*rooms*] 
#   if muc/multi-user-chat required, give the name of the room that you
#   want to join: room@conference.domain/nick
#   Value type is array
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
# [*user*] 
#   The user or resource ID, like foo@example.com.
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
#  http://logstash.net/docs/1.1.5/inputs/xmpp
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::xmpp(
  $user,
  $type,
  $password,
  $host           = '',
  $message_format = '',
  $format         = '',
  $rooms          = '',
  $tags           = '',
  $debug          = '',
  $add_field      = '',
) {

  require logstash::params

  #### Validate parameters
  if $rooms {
    validate_array($rooms)
    $arr_rooms = join($rooms, "', '")
    $opt_rooms = "  rooms => ['${arr_rooms}']\n"
  }

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

  file { "${logstash::params::configdir}/input_xmpp_${name}":
    ensure  => present,
    content => "input {\n xmpp {\n${opt_add_field}${opt_debug}${opt_format}${opt_host}${opt_message_format}${opt_password}${opt_rooms}${opt_tags}${opt_type}${opt_user} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

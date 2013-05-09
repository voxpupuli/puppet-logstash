# == Define: logstash::output::hipchat
#
#   This output allows you to write events to HipChat.
#
#
# === Parameters
#
# [*color*]
#   Background color for message. HipChat currently supports one of
#   "yellow", "red", "green", "purple", "gray", or "random". (default:
#   yellow)
#   Value type is string
#   Default value: "yellow"
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
# [*format*]
#   Message format to send, event tokens are usable here.
#   Value type is string
#   Default value: "%{@message}"
#   This variable is optional
#
# [*from*]
#   The name the message will appear be sent from.
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*room_id*]
#   The ID or name of the room.
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
# [*token*]
#   The HipChat authentication token.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*trigger_notify*]
#   Whether or not this message should trigger a notification for people
#   in the room.
#   Value type is boolean
#   Default value: false
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
# [*instances*]
#   Array of instance names to which this define is.
#   Value type is array
#   Default value: [ 'array' ]
#   This variable is optional
#
# === Extra information
#
#  This define is created based on LogStash version 1.1.12
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.12/outputs/hipchat
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::hipchat (
  $room_id,
  $token,
  $color          = '',
  $format         = '',
  $from           = '',
  $fields         = '',
  $tags           = '',
  $exclude_tags   = '',
  $trigger_notify = '',
  $type           = '',
  $instances      = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_hipchat_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/hipchat/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_hipchat_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/hipchat/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if ($trigger_notify != '') {
    validate_bool($trigger_notify)
    $opt_trigger_notify = "  trigger_notify => ${trigger_notify}\n"
  }

  if ($room_id != '') {
    validate_string($room_id)
    $opt_room_id = "  room_id => \"${room_id}\"\n"
  }

  if ($from != '') {
    validate_string($from)
    $opt_from = "  from => \"${from}\"\n"
  }

  if ($token != '') {
    validate_string($token)
    $opt_token = "  token => \"${token}\"\n"
  }

  if ($format != '') {
    validate_string($format)
    $opt_format = "  format => \"${format}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($color != '') {
    validate_string($color)
    $opt_color = "  color => \"${color}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n hipchat {\n${opt_color}${opt_exclude_tags}${opt_fields}${opt_format}${opt_from}${opt_room_id}${opt_tags}${opt_token}${opt_trigger_notify}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

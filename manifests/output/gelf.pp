# == Define: logstash::output::gelf
#
#   GELF output. This is most useful if you want to use logstash to output
#   events to graylog2.  More information at
#   http://www.graylog2.org/about/gelf
#
#
# === Parameters
#
# [*chunksize*] 
#   The GELF chunksize. You usually don't need to change this.
#   Value type is number
#   Default value: 1420
#   This variable is optional
#
# [*custom_fields*] 
#   The GELF custom field mappings. GELF supports arbitrary attributes as
#   custom fields. This exposes that. Exclude the _ portion of the field
#   name e.g. custom_fields =&gt; ['foo_field', 'some_value']
#   setsfoofield=some_value`
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*exclude_tags*] 
#   Only handle events without any of these tags. Note this check is
#   additional to type and tags.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*facility*] 
#   The GELF facility. Dynamic values like %{foo} are permitted here; this
#   is useful if you need to use a value from the event as the facility
#   name.
#   Value type is string
#   Default value: "logstash-gelf"
#   This variable is optional
#
# [*fields*] 
#   Only handle events with all of these fields. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*file*] 
#   The GELF file; this is usually the source code file in your program
#   where the log event originated. Dynamic values like %{foo} are
#   permitted here.
#   Value type is string
#   Default value: "%{@source_path}"
#   This variable is optional
#
# [*host*] 
#   graylog2 server address
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*level*] 
#   The GELF message level. Dynamic values like %{level} are permitted
#   here; useful if you want to parse the 'log level' from an event and
#   use that as the gelf level/severity.  Values here can be integers
#   [0..7] inclusive or any of "debug", "info", "warn", "error", "fatal",
#   "unknown" (case insensitive). Single-character versions of these are
#   also valid, "d", "i", "w", "e", "f", "u"
#   Value type is array
#   Default value: ["%{severity}", "INFO"]
#   This variable is optional
#
# [*line*] 
#   The GELF line number; this is usually the line number in your program
#   where the log event originated. Dynamic values like %{foo} are
#   permitted here, but the value should be a number.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*port*] 
#   graylog2 server port
#   Value type is number
#   Default value: 12201
#   This variable is optional
#
# [*sender*] 
#   Allow overriding of the gelf 'sender' field. This is useful if you
#   want to use something other than the event's source host as the
#   "sender" of an event. A common case for this is using the application
#   name instead of the hostname.
#   Value type is string
#   Default value: "%{@source_host}"
#   This variable is optional
#
# [*ship_metadata*] 
#   Ship metadata within event object? This will cause logstash to ship
#   any fields in the event (such as those created by grok) in the GELF
#   messages.
#   Value type is boolean
#   Default value: true
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
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.5/outputs/gelf
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::gelf(
  $host,
  $level         = '',
  $exclude_tags  = '',
  $facility      = '',
  $fields        = '',
  $file          = '',
  $chunksize     = '',
  $custom_fields = '',
  $line          = '',
  $port          = '',
  $sender        = '',
  $ship_metadata = '',
  $tags          = '',
  $type          = '',
) {

  require logstash::params

  #### Validate parameters
  if $level {
    validate_array($level)
    $arr_level = join($level, "', '")
    $opt_level = "  level => ['${arr_level}']\n"
  }

  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, "', '")
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, "', '")
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $ship_metadata {
    validate_bool($ship_metadata)
    $opt_ship_metadata = "  ship_metadata => ${ship_metadata}\n"
  }

  if $custom_fields {
    validate_hash($custom_fields)
    $arr_custom_fields = inline_template('<%= custom_fields.to_a.flatten.inspect %>')
    $opt_custom_fields = "  custom_fields => ${arr_custom_fields}\n"
  }

  if $chunksize {
    if ! is_numeric($chunksize) {
      fail("\"${chunksize}\" is not a valid chunksize parameter value")
    }
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    }
  }

  if $sender { 
    validate_string($sender)
    $opt_sender = "  sender => \"${sender}\"\n"
  }

  if $host { 
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $line { 
    validate_string($line)
    $opt_line = "  line => \"${line}\"\n"
  }

  if $file { 
    validate_string($file)
    $opt_file = "  file => \"${file}\"\n"
  }

  if $facility { 
    validate_string($facility)
    $opt_facility = "  facility => \"${facility}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_gelf_${name}":
    ensure  => present,
    content => "output {\n gelf {\n${opt_chunksize}${opt_custom_fields}${opt_exclude_tags}${opt_facility}${opt_fields}${opt_file}${opt_host}${opt_level}${opt_line}${opt_port}${opt_sender}${opt_ship_metadata}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

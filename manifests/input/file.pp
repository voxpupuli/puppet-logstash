# == Define: logstash::input::file
#
#   Stream events from files.  By default, each event is assumed to be one
#   line. If you want to join lines, you'll want to use the multiline
#   filter.  Files are followed in a manner similar to "tail -0F". File
#   rotation is detected and handled by this input.
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
# [*discover_interval*] 
#   How often we expand globs to discover new files to watch.
#   Value type is number
#   Default value: 15
#   This variable is optional
#
# [*exclude*] 
#   Exclusions (matched against the filename, not full path). Globs are
#   valid here, too. For example, if you have  path =&gt; "/var/log/*"  
#   you might want to exclude gzipped files:  exclude =&gt; "*.gz"
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*format*] 
#   The format of input data (plain, json, json_event)
#   Value can be any of: "plain", "json", "json_event"
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
# [*path*] 
#   The path to the file to use as an input. You can use globs here, such
#   as "/var/log/*.log" Paths must be absolute and cannot be relative.
#   Value type is array
#   Default value: None
#   This variable is required
#
# [*sincedb_path*] 
#   Where to write the since database (keeps track of the current position
#   of monitored log files). Defaults to the value of environment variable
#   "$SINCEDB_PATH" or "$HOME/.sincedb".
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*sincedb_write_interval*] 
#   How often to write a since database with the current position of
#   monitored log files.
#   Value type is number
#   Default value: 15
#   This variable is optional
#
# [*start_position*] 
#   Choose where logstash starts initially reading files - at the
#   beginning or at the end. The default behavior treats files like live
#   streams and thus starts at the end. If you have old data you want to
#   import, set this to 'beginning'  This option only modifieds "first
#   contact" situations where a file is new and not seen before. If a file
#   has already been seen before, this option has no effect.
#   Value can be any of: "beginning", "end"
#   Default value: "end"
#   This variable is optional
#
# [*stat_interval*] 
#   How often we stat files to see if they have been modified. Increasing
#   this interval will decrease the number of system calls we make, but
#   increase the time to detect new log lines.
#   Value type is number
#   Default value: 1
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
#  http://logstash.net/docs/1.1.5/inputs/file
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::file(
  $type,
  $path,
  $discover_interval      = '',
  $exclude                = '',
  $format                 = '',
  $message_format         = '',
  $debug                  = '',
  $sincedb_path           = '',
  $sincedb_write_interval = '',
  $start_position         = '',
  $stat_interval          = '',
  $tags                   = '',
  $add_field              = '',
) {

  require logstash::params

  #### Validate parameters
  if $path {
    validate_array($path)
    $arr_path = join($path, "', '")
    $opt_path = "  path => ['${arr_path}']\n"
  }

  if $exclude {
    validate_array($exclude)
    $arr_exclude = join($exclude, "', '")
    $opt_exclude = "  exclude => ['${arr_exclude}']\n"
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

  if $stat_interval {
    if ! is_numeric($stat_interval) {
      fail("\"${stat_interval}\" is not a valid stat_interval parameter value")
    }
  }

  if $sincedb_write_interval {
    if ! is_numeric($sincedb_write_interval) {
      fail("\"${sincedb_write_interval}\" is not a valid sincedb_write_interval parameter value")
    }
  }

  if $discover_interval {
    if ! is_numeric($discover_interval) {
      fail("\"${discover_interval}\" is not a valid discover_interval parameter value")
    }
  }

  if $format {
    if ! ($format in ['plain', 'json', 'json_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if $start_position {
    if ! ($start_position in ['beginning', 'end']) {
      fail("\"${start_position}\" is not a valid start_position parameter value")
    } else {
      $opt_start_position = "  start_position => \"${start_position}\"\n"
    }
  }

  if $message_format { 
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $sincedb_path { 
    validate_string($sincedb_path)
    $opt_sincedb_path = "  sincedb_path => \"${sincedb_path}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/input_file_${name}":
    ensure  => present,
    content => "input {\n file {\n${opt_add_field}${opt_debug}${opt_discover_interval}${opt_exclude}${opt_format}${opt_message_format}${opt_path}${opt_sincedb_path}${opt_sincedb_write_interval}${opt_start_position}${opt_stat_interval}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

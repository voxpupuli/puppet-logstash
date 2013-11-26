# == Define: logstash::input::generator
#
#   Generate random log events.  The general intention of this is to test
#   performance of plugins.  An event is generated first
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
# [*codec*]
#   A codec value.  It is recommended that you use the logstash_codec function
#   to derive this variable. Example: logstash_codec('graphite', {'charset' => 'UTF-8'})
#   but you could just pass a string, Example: "graphite{ charset => 'UTF-8' }"
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*conditional*]
#   Surrounds the rule with a conditional.  It is recommended that you use the
#   logstash_conditional function, Example: logstash_conditional('[type] == "apache"')
#   or, Example: logstash_conditional(['[loglevel] == "ERROR"','[deployment] == "production"'], 'or')
#   but you could just pass a string, Example: 'if [loglevel] == "ERROR" or [deployment] == "production" {'
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*count*]
#   Set how many messages should be generated.  The default, 0, means
#   generate an unlimited number of events.
#   Value type is number
#   Default value: 0
#   This variable is optional
#
# [*debug*]
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*lines*]
#   The lines to emit, in order. This option cannot be used with the
#   'message' setting.  Example:  input {   generator {     lines =&gt; [
#   "line 1",       "line 2",       "line 3"     ]   }    # Emit all lines
#   3 times.   count =&gt; 3 }   The above will emit "line 1" then "line
#   2" then "line", then "line 1", etc...
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*message*]
#   The message string to use in the event.  If you set this to 'stdin'
#   then this plugin will read a single line from stdin and use that as
#   the message string for every event.  Otherwise, this value will be
#   used verbatim as the event message.
#   Value type is string
#   Default value: "Hello world!"
#   This variable is optional
#
# [*tags*]
#   Add any number of arbitrary tags to your event.  This can help with
#   processing later.
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*threads*]
#   Set this to the number of threads you want this input to spawn. This
#   is the same as declaring the input multiple times
#   Value type is number
#   Default value: 1
#   This variable is optional
#
# [*type*]
#   Label this input with a type. Types are used mainly for filter
#   activation.  If you create an input with type "foobar", then only
#   filters which also have type "foobar" will act on them.  The type is
#   also stored as part of the event itself, so you can also use the type
#   to search for in the web interface.  If you try to set a type on an
#   event that already has one (for example when you send an event from a
#   shipper to an indexer) then a new input will not override the existing
#   type. A type set at the shipper stays with that event for its life
#   even when sent to another LogStash server.
#   Value type is string
#   Default value: None
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
#  This define is created based on LogStash version 1.2.2
#  Extra information about this input can be found at:
#  http://logstash.net/docs/1.2.2/inputs/generator
#
#  Need help? http://logstash.net/docs/1.2.2/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
# === Contributors
#
# * Luke Chavers <mailto:vmadman@gmail.com> - Added Initial Logstash 1.2.x Support
#
define logstash::input::generator (
  $type,
  $message        = '',
  $count          = '',
  $debug          = '',
  $lines          = '',
  $codec          = '',
  $conditional    = '',
  $tags           = '',
  $threads        = '',
  $add_field      = '',
  $instances      = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_generator_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/generator/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_generator_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/generator/${name}"

  }

  #### Validate parameters

  if ($conditional != '') {
    validate_string($conditional)
    $opt_indent = "   "
    $opt_cond_start = " ${conditional}\n "
    $opt_cond_end = "  }\n "
  } else {
    $opt_indent = "  "
    $opt_cond_end = " "
  }

  if ($codec != '') {
    validate_string($codec)
    $opt_codec = "${opt_indent}codec => ${codec}\n"
  }

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "${opt_indent}tags => ['${arr_tags}']\n"
  }

  if ($lines != '') {
    validate_array($lines)
    $arr_lines = join($lines, '\', \'')
    $opt_lines = "${opt_indent}lines => ['${arr_lines}']\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "${opt_indent}debug => ${debug}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "${opt_indent}add_field => ${arr_add_field}\n"
  }

  if ($threads != '') {
    if ! is_numeric($threads) {
      fail("\"${threads}\" is not a valid threads parameter value")
    } else {
      $opt_threads = "${opt_indent}threads => ${threads}\n"
    }
  }

  if ($count != '') {
    if ! is_numeric($count) {
      fail("\"${count}\" is not a valid count parameter value")
    } else {
      $opt_count = "${opt_indent}count => ${count}\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  if ($message != '') {
    validate_string($message)
    $opt_message = "${opt_indent}message => \"${message}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n${opt_cond_start} generator {\n${opt_add_field}${opt_count}${opt_debug}${opt_lines}${opt_message}${opt_codec}${opt_tags}${opt_threads}${opt_type}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

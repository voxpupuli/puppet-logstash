# == Define: logstash::input::syslog
#
#   Read syslog messages as events over the network.  This input is a good
#   choice if you already use syslog today. It is also a good choice if
#   you want to receive logs from appliances and network devices where you
#   cannot run your own log collector.  Of course, 'syslog' is a very
#   muddy term. This input only supports RFC3164 syslog with some small
#   modifications. The date format is allowed to be RFC3164 style or
#   ISO8601. Otherwise the rest of the RFC3164 must be obeyed. If you do
#   not use RFC3164, do not use this input.  Note: this input will start
#   listeners on both TCP and UDP
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
# [*debug*]
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*facility_labels*]
#   Labels for facility levels This comes from RFC3164.
#   Value type is array
#   Default value: ["kernel", "user-level", "mail", "system", "security/authorization", "syslogd", "line printer", "network news", "UUCP", "clock", "security/authorization", "FTP", "NTP", "log audit", "log alert", "clock", "local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7"]
#   This variable is optional
#
# [*host*]
#   The address to listen on
#   Value type is string
#   Default value: "0.0.0.0"
#   This variable is optional
#
# [*port*]
#   The port to listen on. Remember that ports less than 1024 (privileged
#   ports) may require root to use.
#   Value type is number
#   Default value: 514
#   This variable is optional
#
# [*severity_labels*]
#   Labels for severity levels This comes from RFC3164.
#   Value type is array
#   Default value: ["Emergency", "Alert", "Critical", "Error", "Warning", "Notice", "Informational", "Debug"]
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
#   to search for in the web interface.  If you try to set a type on an
#   event that already has one (for example when you send an event from a
#   shipper to an indexer) then a new input will not override the existing
#   type. A type set at the shipper stays with that event for its life
#   even when sent to another LogStash server.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*use_labels*]
#   Use label parsing for severity and facility levels
#   Value type is boolean
#   Default value: true
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
#  http://logstash.net/docs/1.2.2/inputs/syslog
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
define logstash::input::syslog (
  $type,
  $codec           = '',
  $conditional     = '',
  $debug           = '',
  $facility_labels = '',
  $host            = '',
  $charset         = '',
  $port            = '',
  $severity_labels = '',
  $tags            = '',
  $add_field       = '',
  $use_labels      = '',
  $instances       = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_syslog_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/syslog/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_syslog_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/syslog/${name}"

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

  if ($severity_labels != '') {
    validate_array($severity_labels)
    $arr_severity_labels = join($severity_labels, '\', \'')
    $opt_severity_labels = "${opt_indent}severity_labels => ['${arr_severity_labels}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "${opt_indent}tags => ['${arr_tags}']\n"
  }

  if ($facility_labels != '') {
    validate_array($facility_labels)
    $arr_facility_labels = join($facility_labels, '\', \'')
    $opt_facility_labels = "${opt_indent}facility_labels => ['${arr_facility_labels}']\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "${opt_indent}debug => ${debug}\n"
  }

  if ($use_labels != '') {
    validate_bool($use_labels)
    $opt_use_labels = "${opt_indent}use_labels => ${use_labels}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "${opt_indent}add_field => ${arr_add_field}\n"
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "${opt_indent}port => ${port}\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "${opt_indent}host => \"${host}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n${opt_cond_start} syslog {\n${opt_add_field}${opt_debug}${opt_facility_labels}${opt_host}${opt_codec}${opt_port}${opt_severity_labels}${opt_tags}${opt_type}${opt_use_labels}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

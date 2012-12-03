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
# [*format*] 
#   The format of input data (plain, json, json_event)
#   Value can be any of: "plain", "json", "json_event"
#   Default value: None
#   This variable is optional
#
# [*host*] 
#   The address to listen on
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
#   to search for in the web interface.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*use_labels*] 
#   Use label parsing for severity and facility levels
#   Value type is boolean
#   Default value: true
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
#  http://logstash.net/docs/1.1.5/inputs/syslog
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::syslog(
  $type,
  $message_format  = '',
  $facility_labels = '',
  $format          = '',
  $host            = '',
  $debug           = '',
  $port            = '',
  $severity_labels = '',
  $tags            = '',
  $add_field       = '',
  $use_labels      = '',
) {

  require logstash::params

  #### Validate parameters
  if $severity_labels {
    validate_array($severity_labels)
    $arr_severity_labels = join($severity_labels, "', '")
    $opt_severity_labels = "  severity_labels => ['${arr_severity_labels}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $facility_labels {
    validate_array($facility_labels)
    $arr_facility_labels = join($facility_labels, "', '")
    $opt_facility_labels = "  facility_labels => ['${arr_facility_labels}']\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $use_labels {
    validate_bool($use_labels)
    $opt_use_labels = "  use_labels => ${use_labels}\n"
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

  if $host { 
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $message_format { 
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/input_syslog_${name}":
    ensure  => present,
    content => "input {\n syslog {\n${opt_add_field}${opt_debug}${opt_facility_labels}${opt_format}${opt_host}${opt_message_format}${opt_port}${opt_severity_labels}${opt_tags}${opt_type}${opt_use_labels} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

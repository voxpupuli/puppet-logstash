# == Define: logstash::output::graphite
#
#   This output allows you to pull metrics from your logs and ship them to
#   graphite. Graphite is an open source tool for storing and graphing
#   metrics.  An example use case: At loggly, some of our applications
#   emit aggregated stats in the logs every 10 seconds. Using the grok
#   filter and this output, I can capture the metric values from the logs
#   and emit them to graphite.
#
#
# === Parameters
#
# [*debug*]
#   Enable debug output
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*exclude_metrics*]
#   Exclude regex matched metric names, by default exclude unresolved
#   %{field} strings
#   Value type is array
#   Default value: ["%{[^}]+}"]
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
# [*fields_are_metrics*]
#   Indicate that the event @fields should be treated as metrics and will
#   be sent as is to graphite
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*host*]
#   The address of the graphite server.
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*include_metrics*]
#   Include only regex matched metric names
#   Value type is array
#   Default value: [".*"]
#   This variable is optional
#
# [*metrics*]
#   The metric(s) to use. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is a hash
#   field with key of the metric name, value of the metric value. Example:
#   [ "%{@source_host}/uptime", "%{uptime_1m}" ]   The value will be
#   coerced to a floating point value. Values which cannot be coerced will
#   zero (0)
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*metrics_format*]
#   Defines format of the metric string. The placeholder '*' will be
#   replaced with the name of the actual metric.  metrics_format =&gt;
#   "foo.bar.*.sum"   NOTE: If no metrics_format is defined the name of
#   the metric will be used as fallback.
#   Value type is string
#   Default value: "*"
#   This variable is optional
#
# [*port*]
#   The port to connect on your graphite server.
#   Value type is number
#   Default value: 2003
#   This variable is optional
#
# [*reconnect_interval*]
#   Interval between reconnect attempts to carboon
#   Value type is number
#   Default value: 2
#   This variable is optional
#
# [*resend_on_failure*]
#   Should metrics be resend on failure?
#   Value type is boolean
#   Default value: false
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
#  http://logstash.net/docs/1.1.12/outputs/graphite
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::graphite (
  $debug              = '',
  $exclude_metrics    = '',
  $exclude_tags       = '',
  $fields             = '',
  $fields_are_metrics = '',
  $host               = '',
  $include_metrics    = '',
  $metrics            = '',
  $metrics_format     = '',
  $port               = '',
  $reconnect_interval = '',
  $resend_on_failure  = '',
  $tags               = '',
  $type               = '',
  $instances          = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_graphite_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/graphite/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_graphite_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/graphite/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($exclude_metrics != '') {
    validate_array($exclude_metrics)
    $arr_exclude_metrics = join($exclude_metrics, '\', \'')
    $opt_exclude_metrics = "  exclude_metrics => ['${arr_exclude_metrics}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if ($include_metrics != '') {
    validate_array($include_metrics)
    $arr_include_metrics = join($include_metrics, '\', \'')
    $opt_include_metrics = "  include_metrics => ['${arr_include_metrics}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($fields_are_metrics != '') {
    validate_bool($fields_are_metrics)
    $opt_fields_are_metrics = "  fields_are_metrics => ${fields_are_metrics}\n"
  }

  if ($resend_on_failure != '') {
    validate_bool($resend_on_failure)
    $opt_resend_on_failure = "  resend_on_failure => ${resend_on_failure}\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if ($metrics != '') {
    validate_hash($metrics)
    $var_metrics = $metrics
    $arr_metrics = inline_template('<%= "["+var_metrics.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_metrics = "  metrics => ${arr_metrics}\n"
  }

  if ($reconnect_interval != '') {
    if ! is_numeric($reconnect_interval) {
      fail("\"${reconnect_interval}\" is not a valid reconnect_interval parameter value")
    } else {
      $opt_reconnect_interval = "  reconnect_interval => ${reconnect_interval}\n"
    }
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if ($metrics_format != '') {
    validate_string($metrics_format)
    $opt_metrics_format = "  metrics_format => \"${metrics_format}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n graphite {\n${opt_debug}${opt_exclude_metrics}${opt_exclude_tags}${opt_fields}${opt_fields_are_metrics}${opt_host}${opt_include_metrics}${opt_metrics}${opt_metrics_format}${opt_port}${opt_reconnect_interval}${opt_resend_on_failure}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

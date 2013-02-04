# == Define: logstash::output::opentsdb
#
#   This output allows you to pull metrics from your logs and ship them to
#   opentsdb. Opentsdb is an open source tool for storing and graphing
#   metrics.
#
#
# === Parameters
#
# [*debug*]
#   Enable debugging. Tries to pretty-print the entire event object.
#   Value type is boolean
#   Default value: None
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
# [*host*]
#   The address of the opentsdb server.
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*metrics*]
#   The metric(s) to use. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is an array
#   field with key of the metric name, value of the metric value, and
#   multiple tag,values . Example:  [   "%{@source_host}/uptime",
#   %{uptime_1m} " ,   "hostname" ,   "%{@source_host}   "anotherhostname"
#   ,   "%{@source_host} ]   The value will be coerced to a floating point
#   value. Values which cannot be coerced will zero (0)
#   Value type is array
#   Default value: None
#   This variable is required
#
# [*port*]
#   The port to connect on your graphite server.
#   Value type is number
#   Default value: 4242
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
#  This define is created based on LogStash version 1.1.9
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.9/outputs/opentsdb
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::opentsdb (
  $metrics,
  $debug        = '',
  $fields       = '',
  $host         = '',
  $exclude_tags = '',
  $port         = '',
  $tags         = '',
  $type         = ''
) {


  require logstash::params

  #### Validate parameters
  if $metrics {
    validate_array($metrics)
    $arr_metrics = join($metrics, '\', \'')
    $opt_metrics = "  metrics => ['${arr_metrics}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
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

  #### Write config file

  file { "${logstash::params::configdir}/output_opentsdb_${name}":
    ensure  => present,
    content => "output {\n opentsdb {\n${opt_debug}${opt_exclude_tags}${opt_fields}${opt_host}${opt_metrics}${opt_port}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

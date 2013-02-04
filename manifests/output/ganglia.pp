# == Define: logstash::output::ganglia
#
#   This output allows you to pull metrics from your logs and ship them to
#   ganglia's gmond. This is heavily based on the graphite output.
#
#
# === Parameters
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
#   The address of the graphite server.
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*lifetime*]
#   Lifetime in seconds of this metric
#   Value type is number
#   Default value: 300
#   This variable is optional
#
# [*max_interval*]
#   Maximum time in seconds between gmetric calls for this metric.
#   Value type is number
#   Default value: 60
#   This variable is optional
#
# [*metric*]
#   The metric to use. This supports dynamic strings like %{@source_host}
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*metric_type*]
#   The type of value for this metric.
#   Value can be any of: "string", "int8", "uint8", "int16", "uint16",
#   "int32", "uint32", "float", "double"
#   Default value: "uint8"
#   This variable is optional
#
# [*port*]
#   The port to connect on your graphite server.
#   Value type is number
#   Default value: 8649
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
# [*units*]
#   Gmetric units for metric, such as "kb/sec" or "ms" or whatever unit
#   this metric uses.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*value*]
#   The value to use. This supports dynamic strings like %{bytes} It will
#   be coerced to a floating point value. Values which cannot be coerced
#   will zero (0)
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
#  This define is created based on LogStash version 1.1.9
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.9/outputs/ganglia
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::ganglia (
  $value,
  $metric,
  $metric_type  = '',
  $lifetime     = '',
  $max_interval = '',
  $fields       = '',
  $host         = '',
  $port         = '',
  $tags         = '',
  $type         = '',
  $units        = '',
  $exclude_tags = ''
) {


  require logstash::params

  #### Validate parameters
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

  if $lifetime {
    if ! is_numeric($lifetime) {
      fail("\"${lifetime}\" is not a valid lifetime parameter value")
    } else {
      $opt_lifetime = "  lifetime => ${lifetime}\n"
    }
  }

  if $max_interval {
    if ! is_numeric($max_interval) {
      fail("\"${max_interval}\" is not a valid max_interval parameter value")
    } else {
      $opt_max_interval = "  max_interval => ${max_interval}\n"
    }
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if $metric_type {
    if ! ($metric_type in ['string', 'int8', 'uint8', 'int16', 'uint16', 'int32', 'uint32', 'float', 'double']) {
      fail("\"${metric_type}\" is not a valid metric_type parameter value")
    } else {
      $opt_metric_type = "  metric_type => \"${metric_type}\"\n"
    }
  }

  if $metric {
    validate_string($metric)
    $opt_metric = "  metric => \"${metric}\"\n"
  }

  if $host {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $units {
    validate_string($units)
    $opt_units = "  units => \"${units}\"\n"
  }

  if $value {
    validate_string($value)
    $opt_value = "  value => \"${value}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_ganglia_${name}":
    ensure  => present,
    content => "output {\n ganglia {\n${opt_exclude_tags}${opt_fields}${opt_host}${opt_lifetime}${opt_max_interval}${opt_metric}${opt_metric_type}${opt_port}${opt_tags}${opt_type}${opt_units}${opt_value} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

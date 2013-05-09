# == Define: logstash::output::statsd
#
#   statsd is a server for aggregating counters and other metrics to ship
#   to graphite.  The most basic coverage of this plugin is that the
#   'namespace', 'sender', and 'metric' names are combined into the full
#   metric path like so:  namespace.sender.metric   The general idea is
#   that you send statsd count or latency data and every few seconds it
#   will emit the aggregated values to graphite (aggregates like average,
#   max, stddev, etc)  You can learn about statsd here:
#   http://codeascraft.etsy.com/2011/02/15/measure-anything-measure-everything/
#   https://github.com/etsy/statsd A simple example usage of this is to
#   count HTTP hits by response code; to learn more about that, check out
#   the log metrics tutorial
#
#
# === Parameters
#
# [*count*]
#   A count metric. metric_name =&gt; count as hash
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*debug*]
#   The final metric sent to statsd will look like the following (assuming
#   defaults) logstash.sender.file_name  Enable debugging output?
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*decrement*]
#   A decrement metric. metric names as array.
#   Value type is array
#   Default value: []
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
#   The address of the Statsd server.
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*increment*]
#   An increment metric. metric names as array.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*namespace*]
#   The statsd namespace to use for this metric
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*port*]
#   The port to connect to on your statsd server.
#   Value type is number
#   Default value: 8125
#   This variable is optional
#
# [*sample_rate*]
#   The sample rate for the metric
#   Value type is number
#   Default value: 1
#   This variable is optional
#
# [*sender*]
#   The name of the sender. Dots will be replaced with underscores
#   Value type is string
#   Default value: "%{@source_host}"
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*timing*]
#   A timing metric. metric_name =&gt; duration as hash
#   Value type is hash
#   Default value: {}
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
#  http://logstash.net/docs/1.1.12/outputs/statsd
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::statsd (
  $count        = '',
  $debug        = '',
  $decrement    = '',
  $exclude_tags = '',
  $fields       = '',
  $host         = '',
  $increment    = '',
  $namespace    = '',
  $port         = '',
  $sample_rate  = '',
  $sender       = '',
  $tags         = '',
  $timing       = '',
  $type         = '',
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_statsd_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/statsd/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_statsd_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/statsd/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($decrement != '') {
    validate_array($decrement)
    $arr_decrement = join($decrement, '\', \'')
    $opt_decrement = "  decrement => ['${arr_decrement}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($increment != '') {
    validate_array($increment)
    $arr_increment = join($increment, '\', \'')
    $opt_increment = "  increment => ['${arr_increment}']\n"
  }

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if ($timing != '') {
    validate_hash($timing)
    $var_timing = $timing
    $arr_timing = inline_template('<%= "["+var_timing.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_timing = "  timing => ${arr_timing}\n"
  }

  if ($count != '') {
    validate_hash($count)
    $var_count = $count
    $arr_count = inline_template('<%= "["+var_count.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_count = "  count => ${arr_count}\n"
  }

  if ($sample_rate != '') {
    if ! is_numeric($sample_rate) {
      fail("\"${sample_rate}\" is not a valid sample_rate parameter value")
    } else {
      $opt_sample_rate = "  sample_rate => ${sample_rate}\n"
    }
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if ($sender != '') {
    validate_string($sender)
    $opt_sender = "  sender => \"${sender}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($namespace != '') {
    validate_string($namespace)
    $opt_namespace = "  namespace => \"${namespace}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n statsd {\n${opt_count}${opt_debug}${opt_decrement}${opt_exclude_tags}${opt_fields}${opt_host}${opt_increment}${opt_namespace}${opt_port}${opt_sample_rate}${opt_sender}${opt_tags}${opt_timing}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

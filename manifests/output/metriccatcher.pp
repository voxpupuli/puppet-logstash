# == Define: logstash::output::metriccatcher
#
#   This output ships metrics to MetricCatcher, allowing you to utilize
#   Coda Hale's Metrics.  More info on MetricCatcher:
#   https://github.com/clearspring/MetricCatcher  At Clearspring, we use
#   it to count the response codes from Apache logs:  metriccatcher {
#   host =&gt; "localhost"     port =&gt; "1420"     type =&gt;
#   "apache-access"     fields =&gt; [ "response" ]     meter =&gt; [
#   "%{@source_host}.apache.response.%{response}", "1" ] }
#
#
# === Parameters
#
# [*biased*]
#   The metrics to send. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is a hash
#   field with key of the metric name, value of the metric value.  The
#   value will be coerced to a floating point value. Values which cannot
#   be coerced will zero (0)
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*counter*]
#   The metrics to send. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is a hash
#   field with key of the metric name, value of the metric value. Example:
#   counter =&gt; [ "%{@source_host}.apache.hits.%{response}, "1" ]  The
#   value will be coerced to a floating point value. Values which cannot
#   be coerced will zero (0)
#   Value type is hash
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
# [*gauge*]
#   The metrics to send. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is a hash
#   field with key of the metric name, value of the metric value.  The
#   value will be coerced to a floating point value. Values which cannot
#   be coerced will zero (0)
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*host*]
#   The address of the MetricCatcher
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*meter*]
#   The metrics to send. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is a hash
#   field with key of the metric name, value of the metric value.  The
#   value will be coerced to a floating point value. Values which cannot
#   be coerced will zero (0)
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*port*]
#   The port to connect on your MetricCatcher
#   Value type is number
#   Default value: 1420
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*timer*]
#   The metrics to send. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is a hash
#   field with key of the metric name, value of the metric value. Example:
#   timer =&gt; [ "%{@sourcehost}.apache.responsetime, "%{response_time}"
#   ]  The value will be coerced to a floating point value. Values which
#   cannot be coerced will zero (0)
#   Value type is hash
#   Default value: None
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
# [*uniform*]
#   The metrics to send. This supports dynamic strings like
#   %{@source_host} for metric names and also for values. This is a hash
#   field with key of the metric name, value of the metric value.  The
#   value will be coerced to a floating point value. Values which cannot
#   be coerced will zero (0)
#   Value type is hash
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
#  This define is created based on LogStash version 1.1.12
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.12/outputs/metriccatcher
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::metriccatcher (
  $biased       = '',
  $counter      = '',
  $exclude_tags = '',
  $fields       = '',
  $gauge        = '',
  $host         = '',
  $meter        = '',
  $port         = '',
  $tags         = '',
  $timer        = '',
  $type         = '',
  $uniform      = '',
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_metriccatcher_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/metriccatcher/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_metriccatcher_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/metriccatcher/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
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

  if ($meter != '') {
    validate_hash($meter)
    $var_meter = $meter
    $arr_meter = inline_template('<%= "["+var_meter.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_meter = "  meter => ${arr_meter}\n"
  }

  if ($biased != '') {
    validate_hash($biased)
    $var_biased = $biased
    $arr_biased = inline_template('<%= "["+var_biased.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_biased = "  biased => ${arr_biased}\n"
  }

  if ($gauge != '') {
    validate_hash($gauge)
    $var_gauge = $gauge
    $arr_gauge = inline_template('<%= "["+var_gauge.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_gauge = "  gauge => ${arr_gauge}\n"
  }

  if ($uniform != '') {
    validate_hash($uniform)
    $var_uniform = $uniform
    $arr_uniform = inline_template('<%= "["+var_uniform.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_uniform = "  uniform => ${arr_uniform}\n"
  }

  if ($counter != '') {
    validate_hash($counter)
    $var_counter = $counter
    $arr_counter = inline_template('<%= "["+var_counter.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_counter = "  counter => ${arr_counter}\n"
  }

  if ($timer != '') {
    validate_hash($timer)
    $var_timer = $timer
    $arr_timer = inline_template('<%= "["+var_timer.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_timer = "  timer => ${arr_timer}\n"
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
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
    content => "output {\n metriccatcher {\n${opt_biased}${opt_counter}${opt_exclude_tags}${opt_fields}${opt_gauge}${opt_host}${opt_meter}${opt_port}${opt_tags}${opt_timer}${opt_type}${opt_uniform} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

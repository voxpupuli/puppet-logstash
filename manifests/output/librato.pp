# == Define: logstash::output::librato
#
#
#
# === Parameters
#
# [*account_id*]
#   This output lets you send metrics, annotations and alerts to Librato
#   based on Logstash events  This is VERY experimental and inefficient
#   right now. Your Librato account usually an email address
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*annotation*]
#   Annotations Registers an annotation with Librato The only required
#   field is title and name. start_time and end_time will be set to
#   event.unix_timestamp You can add any other optional annotation values
#   as well. All values will be passed through event.sprintf  Example:
#   ["title":"Logstash event on %{@sourcehost}", "name":"logstashstream"]
#   or   ["title":"Logstash event", "description":"%{@message}",
#   "name":"logstash_stream"]
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*api_token*]
#   Your Librato API Token
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*batch_size*]
#   Named metrics (NYI) These allow multiple metrics/annotations in the
#   same output Examples: (Gauge) apache_bytes =&gt; ["type", "gauge",
#   "source", "%{@source_host}", "value", "%{bytes_received}"] (Counter)
#   messages_received =&gt; ["type", "counter", "source",
#   "%{@source_host}", "value", "1"] config /[A-Za-z0-9.:_-]+/, :validate
#   =&gt; :hash Batch size Number of events to batch up before sending to
#   Librato.
#   Value type is string
#   Default value: "10"
#   This variable is optional
#
# [*counter*]
#   Counters Send data to Librato as a counter  Example:   ["value", "1",
#   "source", "%{@sourcehost}", "name", "messagesreceived"] Additionally,
#   you can override the measure_time for the event. Must be a unix
#   timestamp:   ["value", "1", "source", "%{@sourcehost}", "name",
#   "messagesreceived", "measuretime", "%{myunixtime_field}"] Default is
#   to use the event's timestamp
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
# [*fields*]
#   Only handle events with all of these fields. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*gauge*]
#   Gauges Send data to Librato as a gauge  Example:   ["value",
#   "%{bytesrecieved}", "source", "%{@sourcehost}", "name", "apachebytes"]
#   Additionally, you can override the measure_time for the event. Must be
#   a unix timestamp:   ["value", "%{bytesrecieved}", "source",
#   "%{@sourcehost}", "name", "apachebytes","measuretime",
#   "%{myunixtime_field}] Default is to use the event's timestamp
#   Value type is hash
#   Default value: {}
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
#  http://logstash.net/docs/1.1.12/outputs/librato
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::librato (
  $account_id,
  $api_token,
  $exclude_tags = '',
  $batch_size   = '',
  $counter      = '',
  $annotation   = '',
  $fields       = '',
  $gauge        = '',
  $tags         = '',
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
    $conffiles    = suffix($confdirstart, "/config/output_librato_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/librato/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_librato_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/librato/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($counter != '') {
    validate_hash($counter)
    $var_counter = $counter
    $arr_counter = inline_template('<%= "["+var_counter.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_counter = "  counter => ${arr_counter}\n"
  }

  if ($annotation != '') {
    validate_hash($annotation)
    $var_annotation = $annotation
    $arr_annotation = inline_template('<%= "["+var_annotation.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_annotation = "  annotation => ${arr_annotation}\n"
  }

  if ($gauge != '') {
    validate_hash($gauge)
    $var_gauge = $gauge
    $arr_gauge = inline_template('<%= "["+var_gauge.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_gauge = "  gauge => ${arr_gauge}\n"
  }

  if ($api_token != '') {
    validate_string($api_token)
    $opt_api_token = "  api_token => \"${api_token}\"\n"
  }

  if ($batch_size != '') {
    validate_string($batch_size)
    $opt_batch_size = "  batch_size => \"${batch_size}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($account_id != '') {
    validate_string($account_id)
    $opt_account_id = "  account_id => \"${account_id}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n librato {\n${opt_account_id}${opt_annotation}${opt_api_token}${opt_batch_size}${opt_counter}${opt_exclude_tags}${opt_fields}${opt_gauge}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

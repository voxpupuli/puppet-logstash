# == Define: logstash::output::cloudwatch
#
#   This output lets you aggregate and send metric data to AWS CloudWatch
#   Summary:  This plugin is intended to be used on a logstash indexer
#   agent (but that is not the only way, see below.)  In the intended
#   scenario, one cloudwatch output plugin is configured, on the logstash
#   indexer node, with just AWS API credentials, and possibly a region
#   and/or a namespace.  The output looks for fields present in events,
#   and when it finds them, it uses them to calculate aggregate
#   statistics.  If the metricname option is set in this output, then any
#   events which pass through it will be aggregated &amp; sent to
#   CloudWatch, but that is not recommended.  The intended use is to NOT
#   set the metricname option here, and instead to add a CW_metricname
#   field (and other fields) to only the events you want sent to
#   CloudWatch.  When events pass through this output they are queued for
#   background aggregation and sending, which happens every minute by
#   default.  The queue has a maximum size, and when it is full aggregated
#   statistics will be sent to CloudWatch ahead of schedule. Whenever this
#   happens a warning message is written to logstash's log.  If you see
#   this you should increase the queue_size configuration option to avoid
#   the extra API calls.  The queue is emptied every time we send data to
#   CloudWatch.  Note: when logstash is stopped the queue is destroyed
#   before it can be processed. This is a known limitation of logstash and
#   will hopefully be addressed in a future version.  Details:  There are
#   two ways to configure this plugin, and they can be used in
#   combination: event fields &amp; per-output defaults  Event Field
#   configuration... You add fields to your events in inputs &amp; filters
#   and this output reads those fields to aggregate events.  The names of
#   the fields read are configurable via the field_* options.  Per-output
#   defaults... You set universal defaults in this output plugin's
#   configuration, and if an event does not have a field for that option
#   then the default is used.  Notice, the event fields take precedence
#   over the per-output defaults.  At a minimum events must have a "metric
#   name" to be sent to CloudWatch. This can be achieved either by
#   providing a default here OR by adding a CW_metricname field. By
#   default, if no other configuration is provided besides a metric name,
#   then events will be counted (Unit: Count, Value: 1) by their metric
#   name (either a default or from their CW_metricname field)  Other
#   fields which can be added to events to modify the behavior of this
#   plugin are, CW_namespace, CW_unit, CW_value, and CW_dimensions.  All
#   of these field names are configurable in this output.  You can also
#   set per-output defaults for any of them. See below for details.  Read
#   more about AWS CloudWatch, and the specific of API endpoint this
#   output uses, PutMetricData
#
#
# === Parameters
#
# [*access_key_id*]
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*aws_credentials_file*]
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*dimensions*]
#   The default dimensions [ name, value, ... ] to use for events which do
#   not have a CW_dimensions field
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
# [*field_dimensions*]
#   The name of the field used to set the dimensions on an event metric
#   The field named here, if present in an event, must have an array of
#   one or more key &amp; value pairs, for example...  add_field =&gt; [
#   "CW_dimensions", "Environment", "CW_dimensions", "prod" ]   or,
#   equivalently...  add_field =&gt; [ "CW_dimensions", "Environment" ]
#   add_field =&gt; [ "CW_dimensions", "prod" ]
#   Value type is string
#   Default value: "CW_dimensions"
#   This variable is optional
#
# [*field_metricname*]
#   The name of the field used to set the metric name on an event  The
#   author of this plugin recommends adding this field to events in inputs
#   &amp; filters rather than using the per-output default setting so that
#   one output plugin on your logstash indexer can serve all events (which
#   of course had fields set on your logstash shippers.)
#   Value type is string
#   Default value: "CW_metricname"
#   This variable is optional
#
# [*field_namespace*]
#   The name of the field used to set a different namespace per event
#   Note: Only one namespace can be sent to CloudWatch per API call so
#   setting different namespaces will increase the number of API calls and
#   those cost money.
#   Value type is string
#   Default value: "CW_namespace"
#   This variable is optional
#
# [*field_unit*]
#   The name of the field used to set the unit on an event metric
#   Value type is string
#   Default value: "CW_unit"
#   This variable is optional
#
# [*field_value*]
#   The name of the field used to set the value (float) on an event metric
#   Value type is string
#   Default value: "CW_value"
#   This variable is optional
#
# [*fields*]
#   Only handle events with all of these fields. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*metricname*]
#   The default metric name to use for events which do not have a
#   CW_metricname field.  Beware: If this is provided then all events
#   which pass through this output will be aggregated and sent to
#   CloudWatch, so use this carefully.  Furthermore, when providing this
#   option, you will probably want to also restrict events from passing
#   through this output using event type, tag, and field matching
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*namespace*]
#   The default namespace to use for events which do not have a
#   CW_namespace field
#   Value type is string
#   Default value: "Logstash"
#   This variable is optional
#
# [*queue_size*]
#   How many events to queue before forcing a call to the CloudWatch API
#   ahead of timeframe schedule  Set this to the number of
#   events-per-timeframe you will be sending to CloudWatch to avoid extra
#   API calls
#   Value type is number
#   Default value: 10000
#   This variable is optional
#
# [*region*]
#   Value can be any of: "us-east-1", "us-west-1", "us-west-2",
#   "eu-west-1", "ap-southeast-1", "ap-southeast-2", "ap-northeast-1",
#   "sa-east-1", "us-gov-west-1"
#   Default value: "us-east-1"
#   This variable is optional
#
# [*secret_access_key*]
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*timeframe*]
#   How often to send data to CloudWatch  This does not affect the event
#   timestamps, events will always have their actual timestamp
#   (to-the-minute) sent to CloudWatch.  We only call the API if there is
#   data to send.  See the Rufus Scheduler docs for an explanation of
#   allowed values
#   Value type is string
#   Default value: "1m"
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
# [*unit*]
#   The default unit to use for events which do not have a CW_unit field
#   If you set this option you should probably set the "value" option
#   along with it
#   Value can be any of: "Seconds", "Microseconds", "Milliseconds",
#   "Bytes", "Kilobytes", "Megabytes", "Gigabytes", "Terabytes", "Bits",
#   "Kilobits", "Megabits", "Gigabits", "Terabits", "Percent", "Count",
#   "Bytes/Second", "Kilobytes/Second", "Megabytes/Second",
#   "Gigabytes/Second", "Terabytes/Second", "Bits/Second",
#   "Kilobits/Second", "Megabits/Second", "Gigabits/Second",
#   "Terabits/Second", "Count/Second", "None"
#   Default value: "Count"
#   This variable is optional
#
# [*use_ssl*]
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*value*]
#   The default value to use for events which do not have a CW_value field
#   If provided, this must be a string which can be converted to a float,
#   for example...  "1", "2.34", ".5", and "0.67"   If you set this option
#   you should probably set the unit option along with it
#   Value type is string
#   Default value: "1"
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
#  http://logstash.net/docs/1.1.12/outputs/cloudwatch
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::cloudwatch (
  $access_key_id        = '',
  $aws_credentials_file = '',
  $dimensions           = '',
  $exclude_tags         = '',
  $field_dimensions     = '',
  $field_metricname     = '',
  $field_namespace      = '',
  $field_unit           = '',
  $field_value          = '',
  $fields               = '',
  $metricname           = '',
  $namespace            = '',
  $queue_size           = '',
  $region               = '',
  $secret_access_key    = '',
  $tags                 = '',
  $timeframe            = '',
  $type                 = '',
  $unit                 = '',
  $use_ssl              = '',
  $value                = '',
  $instances            = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_cloudwatch_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/cloudwatch/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_cloudwatch_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/cloudwatch/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

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

  if ($use_ssl != '') {
    validate_bool($use_ssl)
    $opt_use_ssl = "  use_ssl => ${use_ssl}\n"
  }

  if ($dimensions != '') {
    validate_hash($dimensions)
    $var_dimensions = $dimensions
    $arr_dimensions = inline_template('<%= "["+var_dimensions.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_dimensions = "  dimensions => ${arr_dimensions}\n"
  }

  if ($queue_size != '') {
    if ! is_numeric($queue_size) {
      fail("\"${queue_size}\" is not a valid queue_size parameter value")
    } else {
      $opt_queue_size = "  queue_size => ${queue_size}\n"
    }
  }

  if ($unit != '') {
    if ! ($unit in ['Seconds', 'Microseconds', 'Milliseconds', 'Bytes', 'Kilobytes', 'Megabytes', 'Gigabytes', 'Terabytes', 'Bits', 'Kilobits', 'Megabits', 'Gigabits', 'Terabits', 'Percent', 'Count', 'Bytes/Second', 'Kilobytes/Second', 'Megabytes/Second', 'Gigabytes/Second', 'Terabytes/Second', 'Bits/Second', 'Kilobits/Second', 'Megabits/Second', 'Gigabits/Second', 'Terabits/Second', 'Count/Second', 'None']) {
      fail("\"${unit}\" is not a valid unit parameter value")
    } else {
      $opt_unit = "  unit => \"${unit}\"\n"
    }
  }

  if ($region != '') {
    if ! ($region in ['us-east-1', 'us-west-1', 'us-west-2', 'eu-west-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'sa-east-1', 'us-gov-west-1']) {
      fail("\"${region}\" is not a valid region parameter value")
    } else {
      $opt_region = "  region => \"${region}\"\n"
    }
  }

  if ($namespace != '') {
    validate_string($namespace)
    $opt_namespace = "  namespace => \"${namespace}\"\n"
  }

  if ($field_unit != '') {
    validate_string($field_unit)
    $opt_field_unit = "  field_unit => \"${field_unit}\"\n"
  }

  if ($metricname != '') {
    validate_string($metricname)
    $opt_metricname = "  metricname => \"${metricname}\"\n"
  }

  if ($field_value != '') {
    validate_string($field_value)
    $opt_field_value = "  field_value => \"${field_value}\"\n"
  }

  if ($field_namespace != '') {
    validate_string($field_namespace)
    $opt_field_namespace = "  field_namespace => \"${field_namespace}\"\n"
  }

  if ($field_metricname != '') {
    validate_string($field_metricname)
    $opt_field_metricname = "  field_metricname => \"${field_metricname}\"\n"
  }

  if ($secret_access_key != '') {
    validate_string($secret_access_key)
    $opt_secret_access_key = "  secret_access_key => \"${secret_access_key}\"\n"
  }

  if ($field_dimensions != '') {
    validate_string($field_dimensions)
    $opt_field_dimensions = "  field_dimensions => \"${field_dimensions}\"\n"
  }

  if ($timeframe != '') {
    validate_string($timeframe)
    $opt_timeframe = "  timeframe => \"${timeframe}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($aws_credentials_file != '') {
    validate_string($aws_credentials_file)
    $opt_aws_credentials_file = "  aws_credentials_file => \"${aws_credentials_file}\"\n"
  }

  if ($access_key_id != '') {
    validate_string($access_key_id)
    $opt_access_key_id = "  access_key_id => \"${access_key_id}\"\n"
  }

  if ($value != '') {
    validate_string($value)
    $opt_value = "  value => \"${value}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n cloudwatch {\n${opt_access_key_id}${opt_aws_credentials_file}${opt_dimensions}${opt_exclude_tags}${opt_field_dimensions}${opt_field_metricname}${opt_field_namespace}${opt_field_unit}${opt_field_value}${opt_fields}${opt_metricname}${opt_namespace}${opt_queue_size}${opt_region}${opt_secret_access_key}${opt_tags}${opt_timeframe}${opt_type}${opt_unit}${opt_use_ssl}${opt_value} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

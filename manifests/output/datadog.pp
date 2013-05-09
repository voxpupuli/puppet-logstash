# == Define: logstash::output::datadog
#
#
#
# === Parameters
#
# [*alert_type*]
#   Alert type
#   Value can be any of: "info", "error", "warning", "success"
#   Default value: None
#   This variable is optional
#
# [*api_key*]
#   This output lets you send events (for now. soon metrics) to DataDogHQ
#   based on Logstash events  Note that since Logstash maintains no state
#   these will be one-shot events  Your DatadogHQ API key
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*date_happened*]
#   Date Happened
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*dd_tags*]
#   Tags Set any custom tags for this event Default are the Logstash tags
#   if any
#   Value type is array
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
# [*priority*]
#   Priority
#   Value can be any of: "normal", "low"
#   Default value: None
#   This variable is optional
#
# [*source_type_name*]
#   Source type name
#   Value can be any of: "nagios", "hudson", "jenkins", "user", "my apps",
#   "feed", "chef", "puppet", "git", "bitbucket"
#   Default value: "my apps"
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*text*]
#   Text
#   Value type is string
#   Default value: "%{@message}"
#   This variable is optional
#
# [*title*]
#   Title
#   Value type is string
#   Default value: "Logstash event for %{@source_host}"
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
#  http://logstash.net/docs/1.1.12/outputs/datadog
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::datadog (
  $api_key,
  $priority         = '',
  $date_happened    = '',
  $dd_tags          = '',
  $exclude_tags     = '',
  $fields           = '',
  $alert_type       = '',
  $source_type_name = '',
  $tags             = '',
  $text             = '',
  $title            = '',
  $type             = '',
  $instances        = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_datadog_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/datadog/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_datadog_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/datadog/${name}"

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

  if ($dd_tags != '') {
    validate_array($dd_tags)
    $arr_dd_tags = join($dd_tags, '\', \'')
    $opt_dd_tags = "  dd_tags => ['${arr_dd_tags}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($priority != '') {
    if ! ($priority in ['normal', 'low']) {
      fail("\"${priority}\" is not a valid priority parameter value")
    } else {
      $opt_priority = "  priority => \"${priority}\"\n"
    }
  }

  if ($alert_type != '') {
    if ! ($alert_type in ['info', 'error', 'warning', 'success']) {
      fail("\"${alert_type}\" is not a valid alert_type parameter value")
    } else {
      $opt_alert_type = "  alert_type => \"${alert_type}\"\n"
    }
  }

  if ($source_type_name != '') {
    if ! ($source_type_name in ['nagios', 'hudson', 'jenkins', 'user', 'my apps', 'feed', 'chef', 'puppet', 'git', 'bitbucket']) {
      fail("\"${source_type_name}\" is not a valid source_type_name parameter value")
    } else {
      $opt_source_type_name = "  source_type_name => \"${source_type_name}\"\n"
    }
  }

  if ($text != '') {
    validate_string($text)
    $opt_text = "  text => \"${text}\"\n"
  }

  if ($api_key != '') {
    validate_string($api_key)
    $opt_api_key = "  api_key => \"${api_key}\"\n"
  }

  if ($title != '') {
    validate_string($title)
    $opt_title = "  title => \"${title}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($date_happened != '') {
    validate_string($date_happened)
    $opt_date_happened = "  date_happened => \"${date_happened}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n datadog {\n${opt_alert_type}${opt_api_key}${opt_date_happened}${opt_dd_tags}${opt_exclude_tags}${opt_fields}${opt_priority}${opt_source_type_name}${opt_tags}${opt_text}${opt_title}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

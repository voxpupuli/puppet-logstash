# == Define: logstash::output::pagerduty
#
#   PagerDuty output Send specific events to PagerDuty for alerting
#
#
# === Parameters
#
# [*description*]
#   Custom description
#   Value type is string
#   Default value: "Logstash event for %{@source_host}"
#   This variable is optional
#
# [*details*]
#   Event details These might be keys from the logstash event you wish to
#   include tags are automatically included if detected so no need to add
#   them here
#   Value type is hash
#   Default value: {"timestamp"=>"%{@timestamp}", "message"=>"%{@message}"}
#   This variable is optional
#
# [*event_type*]
#   Event type
#   Value can be any of: "trigger", "acknowledge", "resolve"
#   Default value: "trigger"
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
# [*incident_key*]
#   The service key to use You'll need to set this up in PD beforehand
#   Value type is string
#   Default value: "logstash/%{@source_host}/%{@type}"
#   This variable is optional
#
# [*pdurl*]
#   PagerDuty API url You shouldn't need to change this This allows for
#   flexibility should PD iterate the API and Logstash hasn't updated yet
#   Value type is string
#   Default value: "https://events.pagerduty.com/generic/2010-04-15/create_event.json"
#   This variable is optional
#
# [*service_key*]
#   Service API Key
#   Value type is string
#   Default value: None
#   This variable is required
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
#  http://logstash.net/docs/1.1.12/outputs/pagerduty
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::pagerduty (
  $service_key,
  $incident_key = '',
  $event_type   = '',
  $exclude_tags = '',
  $fields       = '',
  $details      = '',
  $pdurl        = '',
  $description  = '',
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
    $conffiles    = suffix($confdirstart, "/config/output_pagerduty_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/pagerduty/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_pagerduty_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/pagerduty/${name}"

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

  if ($details != '') {
    validate_hash($details)
    $var_details = $details
    $arr_details = inline_template('<%= "["+var_details.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_details = "  details => ${arr_details}\n"
  }

  if ($event_type != '') {
    if ! ($event_type in ['trigger', 'acknowledge', 'resolve']) {
      fail("\"${event_type}\" is not a valid event_type parameter value")
    } else {
      $opt_event_type = "  event_type => \"${event_type}\"\n"
    }
  }

  if ($incident_key != '') {
    validate_string($incident_key)
    $opt_incident_key = "  incident_key => \"${incident_key}\"\n"
  }

  if ($service_key != '') {
    validate_string($service_key)
    $opt_service_key = "  service_key => \"${service_key}\"\n"
  }

  if ($pdurl != '') {
    validate_string($pdurl)
    $opt_pdurl = "  pdurl => \"${pdurl}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($description != '') {
    validate_string($description)
    $opt_description = "  description => \"${description}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n pagerduty {\n${opt_description}${opt_details}${opt_event_type}${opt_exclude_tags}${opt_fields}${opt_incident_key}${opt_pdurl}${opt_service_key}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

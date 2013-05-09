# == Define: logstash::filter::syslog_pri
#
#   Filter plugin for logstash to parse the PRI field from the front of a
#   Syslog (RFC3164) message.  If no priority is set, it will default to
#   13 (per RFC).  This filter is based on the original syslog.rb code
#   shipped with logstash.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   syslog_pri {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the syslog_pri plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   syslog_pri {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
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
# [*facility_labels*]
#   Labels for facility levels. This comes from RFC3164.
#   Value type is array
#   Default value: ["kernel", "user-level", "mail", "daemon", "security/authorization", "syslogd", "line printer", "network news", "uucp", "clock", "security/authorization", "ftp", "ntp", "log audit", "log alert", "clock", "local0", "local1", "local2", "local3", "local4", "local5", "local6", "local7"]
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   syslog_pri {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*severity_labels*]
#   Labels for severity levels. This comes from RFC3164.
#   Value type is array
#   Default value: ["emergency", "alert", "critical", "error", "warning", "notice", "informational", "debug"]
#   This variable is optional
#
# [*syslog_pri_field_name*]
#   Name of field which passes in the extracted PRI part of the syslog
#   message
#   Value type is string
#   Default value: "syslog_pri"
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
#   The type to act on. If a type is given, then this filter will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*use_labels*]
#   set the status to experimental/beta/stable Add human-readable names
#   after parsing severity and facility from PRI
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*order*]
#   The order variable decides in which sequence the filters are loaded.
#   Value type is number
#   Default value: 10
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
#  Extra information about this filter can be found at:
#  http://logstash.net/docs/1.1.12/filters/syslog_pri
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::syslog_pri (
  $add_field             = '',
  $add_tag               = '',
  $exclude_tags          = '',
  $facility_labels       = '',
  $remove_tag            = '',
  $severity_labels       = '',
  $syslog_pri_field_name = '',
  $tags                  = '',
  $type                  = '',
  $use_labels            = '',
  $order                 = 10,
  $instances             = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_syslog_pri_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/syslog_pri/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_syslog_pri_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/syslog_pri/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($add_tag != '') {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($facility_labels != '') {
    validate_array($facility_labels)
    $arr_facility_labels = join($facility_labels, '\', \'')
    $opt_facility_labels = "  facility_labels => ['${arr_facility_labels}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($severity_labels != '') {
    validate_array($severity_labels)
    $arr_severity_labels = join($severity_labels, '\', \'')
    $opt_severity_labels = "  severity_labels => ['${arr_severity_labels}']\n"
  }

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($use_labels != '') {
    validate_bool($use_labels)
    $opt_use_labels = "  use_labels => ${use_labels}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if ($order != '') {
    if ! is_numeric($order) {
      fail("\"${order}\" is not a valid order parameter value")
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($syslog_pri_field_name != '') {
    validate_string($syslog_pri_field_name)
    $opt_syslog_pri_field_name = "  syslog_pri_field_name => \"${syslog_pri_field_name}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n syslog_pri {\n${opt_add_field}${opt_add_tag}${opt_exclude_tags}${opt_facility_labels}${opt_remove_tag}${opt_severity_labels}${opt_syslog_pri_field_name}${opt_tags}${opt_type}${opt_use_labels} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

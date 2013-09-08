# == Define: logstash::filter::prune
#
#   The prune filter is for pruning event data from @fileds based on
#   whitelist/blacklist of field names or their values (names and values
#   can also be regular expressions).
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   prune {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the prune plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   prune {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*blacklist_names*]
#   Exclude fields which names match specified regexps, by default exclude
#   unresolved %{field} strings.  filter {    prune {      tags
#   =&gt; [ "apache-accesslog" ]     blacklist_names =&gt; [ "method",
#   "(referrer|status)", "${some}_field" ]   } }
#   Value type is array
#   Default value: ["%{[^}]+}"]
#   This variable is optional
#
# [*blacklist_values*]
#   Exclude specified fields if their values match regexps. In case field
#   values are arrays, the fields are pruned on per array item in case all
#   array items are matched whole field will be deleted.  filter {
#   prune {      tags             =&gt; [ "apache-accesslog" ]
#   blacklist_values =&gt; [ "uripath", "/index.php",
#   "method", "(HEAD|OPTIONS)",                           "status",
#   "^[^2]" ]   } }
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
# [*interpolate*]
#   Trigger whether configation fields and values should be interpolated
#   for dynamic values. Probably adds some performance overhead. Defaults
#   to false.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   prune {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
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
# [*whitelist_names*]
#   Include only fields only if their names match specified regexps,
#   default to empty list which means include everything.  filter {
#   prune {      tags            =&gt; [ "apache-accesslog" ]
#   whitelist_names =&gt; [ "method", "(referrer|status)", "${some}_field"
#   ]   } }
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*whitelist_values*]
#   Include specified fields only if their values match regexps. In case
#   field values are arrays, the fields are pruned on per array item thus
#   only matching array items will be included.  filter {    prune {
#   tags             =&gt; [ "apache-accesslog" ]     whitelist_values
#   =&gt; [ "uripath", "/index.php",                           "method",
#   "(GET|POST)",                           "status", "^[^2]" ]   } }
#   Value type is hash
#   Default value: {}
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
#  http://logstash.net/docs/1.1.12/filters/prune
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::prune (
  $add_field        = '',
  $add_tag          = '',
  $blacklist_names  = '',
  $blacklist_values = '',
  $exclude_tags     = '',
  $interpolate      = '',
  $remove_tag       = '',
  $tags             = '',
  $type             = '',
  $whitelist_names  = '',
  $whitelist_values = '',
  $order            = 10,
  $instances        = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_prune_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/prune/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_prune_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/prune/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($add_tag != '') {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if ($blacklist_names != '') {
    validate_array($blacklist_names)
    $arr_blacklist_names = join($blacklist_names, '\', \'')
    $opt_blacklist_names = "  blacklist_names => ['${arr_blacklist_names}']\n"
  }

  if ($whitelist_names != '') {
    validate_array($whitelist_names)
    $arr_whitelist_names = join($whitelist_names, '\', \'')
    $opt_whitelist_names = "  whitelist_names => ['${arr_whitelist_names}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($interpolate != '') {
    validate_bool($interpolate)
    $opt_interpolate = "  interpolate => ${interpolate}\n"
  }

  if ($whitelist_values != '') {
    validate_hash($whitelist_values)
    $var_whitelist_values = $whitelist_values
    $arr_whitelist_values = inline_template('<%= "["+var_whitelist_values.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_whitelist_values = "  whitelist_values => ${arr_whitelist_values}\n"
  }

  if ($blacklist_values != '') {
    validate_hash($blacklist_values)
    $var_blacklist_values = $blacklist_values
    $arr_blacklist_values = inline_template('<%= "["+var_blacklist_values.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_blacklist_values = "  blacklist_values => ${arr_blacklist_values}\n"
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

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n prune {\n${opt_add_field}${opt_add_tag}${opt_blacklist_names}${opt_blacklist_values}${opt_exclude_tags}${opt_interpolate}${opt_remove_tag}${opt_tags}${opt_type}${opt_whitelist_names}${opt_whitelist_values} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

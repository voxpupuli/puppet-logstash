# == Define: logstash::filter::alter
#
#   The alter filter allows you to do general alterations to fields that
#   are not included in the normal mutate filter.  NOTE: The functionality
#   provided by this plugin is likely to be merged into the 'mutate'
#   filter in future versions.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   alter {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the alter plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   alter {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*coalesce*]
#   Sets the value of field_name to the first nonnull expression among its
#   arguments.  Example:  filter {   alter {     coalesce =&gt; [
#   "field_name", "value1", "value2", "value3", ...     ]   } }
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*condrewrite*]
#   Change the content of the field to the specified value if the actual
#   content is equal to the expected one.  Example:  filter {   alter {
#   condrewrite =&gt; [           "field_name", "expected_value",
#   "new_value"           "field_name2", "expected_value2, "new_value2"
#   ....        ]   } }
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*condrewriteother*]
#   Change the content of the field to the specified value if the content
#   of another field is equal to the expected one.  Example:  filter {
#   alter {     condrewriteother =&gt; [           "field_name",
#   "expected_value", "field_name_to_change", "value",
#   "field_name2", "expected_value2, "field_name_to_change2", "value2",
#   ....     ]   } }
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
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   alter {     remove_tag =&gt; [
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
#  http://logstash.net/docs/1.1.12/filters/alter
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::alter (
  $add_field        = '',
  $add_tag          = '',
  $coalesce         = '',
  $condrewrite      = '',
  $condrewriteother = '',
  $exclude_tags     = '',
  $remove_tag       = '',
  $tags             = '',
  $type             = '',
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
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_alter_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/alter/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_alter_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/alter/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($add_tag != '') {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if ($coalesce != '') {
    validate_array($coalesce)
    $arr_coalesce = join($coalesce, '\', \'')
    $opt_coalesce = "  coalesce => ['${arr_coalesce}']\n"
  }

  if ($condrewrite != '') {
    validate_array($condrewrite)
    $arr_condrewrite = join($condrewrite, '\', \'')
    $opt_condrewrite = "  condrewrite => ['${arr_condrewrite}']\n"
  }

  if ($condrewriteother != '') {
    validate_array($condrewriteother)
    $arr_condrewriteother = join($condrewriteother, '\', \'')
    $opt_condrewriteother = "  condrewriteother => ['${arr_condrewriteother}']\n"
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

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
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
    content => "filter {\n alter {\n${opt_add_field}${opt_add_tag}${opt_coalesce}${opt_condrewrite}${opt_condrewriteother}${opt_exclude_tags}${opt_remove_tag}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

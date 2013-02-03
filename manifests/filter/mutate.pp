# == Define: logstash::filter::mutate
#
#   The mutate filter allows you to do general mutations to fields. You
#   can rename, remove, replace, and modify fields in your events.
#   TODO(sissel): Support regexp replacements like String#gsub ?
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   mutate {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the mutate plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   mutate {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*convert*]
#   Convert a field's value to a different type, like turning a string to
#   an integer. If the field value is an array, all members will be
#   converted. If the field is a hash, no action will be taken.  Valid
#   conversion targets are: integer, float, string  Example:  filter {
#   mutate {     convert =&gt; [ "fieldname", "integer" ]   } }
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
# [*gsub*]
#   Convert a string field by applying a regular expression and a
#   replacement if the field is not a string, no action will be taken
#   This configuration takes an array consisting of 3 elements per
#   field/substitution.  be aware of escaping any backslash in the config
#   file  for example:  filter {   mutate {     gsub =&gt; [       #
#   replace all forward slashes with underscore       "fieldname", "\\/",
#   "_",        # replace backslashes, question marks, hashes and minuses
#   with       # underscore       "fieldname", "[\\?#-]", "_"     ]   } }
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*join*]
#   Join an array with a separator character, does nothing on non-array
#   fields  Example:     filter {   mutate {     join =&gt; ["fieldname",
#   ","]  }      }
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*lowercase*]
#   Convert a string to its lowercase equivalent  Example:  filter {
#   mutate {     lowercase =&gt; [ "fieldname" ]   } }
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*remove*]
#   Remove one or more fields.  Example:  filter {   mutate {     remove
#   =&gt; [ "client" ]  # Removes the 'client' field   } }
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   mutate {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*rename*]
#   Rename one or more fields.  Example:  filter {   mutate {     #
#   Renames the 'HOSTORIP' field to 'client_ip'     rename =&gt; [
#   "HOSTORIP", "client_ip" ]   } }
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*replace*]
#   Replace a field with a new value. The new value can include %{foo}
#   strings to help you build a new value from other parts of the event.
#   Example:  filter {   mutate {     replace =&gt; [ "@message",
#   "%{source_host}: My new message" ]   } }
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*split*]
#   Split a field to an array using a separator character. Only works on
#   string fields.  Example:  filter {   mutate {       split =&gt;
#   ["fieldname", ","]   } }
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*strip*]
#   Strip whitespaces  Example:  filter {   mutate {       strip =&gt;
#   ["field1", "field2"]   } }
#   Value type is array
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
# [*type*]
#   The type to act on. If a type is given, then this filter will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*uppercase*]
#   Convert a string to its uppercase equivalent  Example:  filter {
#   mutate {     uppercase =&gt; [ "fieldname" ]   } }
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*order*]
#   The order variable decides in which sequence the filters are loaded.
#   Value type is number
#   Default value: 10
#   This variable is optional
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
#  Extra information about this filter can be found at:
#  http://logstash.net/docs/1.1.9/filters/mutate
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::mutate (
  $add_field    = '',
  $add_tag      = '',
  $convert      = '',
  $exclude_tags = '',
  $gsub         = '',
  $join         = '',
  $lowercase    = '',
  $remove       = '',
  $remove_tag   = '',
  $rename       = '',
  $replace      = '',
  $split        = '',
  $strip        = '',
  $tags         = '',
  $type         = '',
  $uppercase    = '',
  $order        = 10
) {


  require logstash::params

  #### Validate parameters
  if $remove_tag {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if $add_tag {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if $uppercase {
    validate_array($uppercase)
    $arr_uppercase = join($uppercase, '\', \'')
    $opt_uppercase = "  uppercase => ['${arr_uppercase}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $gsub {
    validate_array($gsub)
    $arr_gsub = join($gsub, '\', \'')
    $opt_gsub = "  gsub => ['${arr_gsub}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $lowercase {
    validate_array($lowercase)
    $arr_lowercase = join($lowercase, '\', \'')
    $opt_lowercase = "  lowercase => ['${arr_lowercase}']\n"
  }

  if $remove {
    validate_array($remove)
    $arr_remove = join($remove, '\', \'')
    $opt_remove = "  remove => ['${arr_remove}']\n"
  }

  if $strip {
    validate_array($strip)
    $arr_strip = join($strip, '\', \'')
    $opt_strip = "  strip => ['${arr_strip}']\n"
  }

  if $add_field {
    validate_hash($add_field)
    $arr_add_field = inline_template('<%= add_field.to_a.flatten.inspect %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if $replace {
    validate_hash($replace)
    $arr_replace = inline_template('<%= replace.to_a.flatten.inspect %>')
    $opt_replace = "  replace => ${arr_replace}\n"
  }

  if $split {
    validate_hash($split)
    $arr_split = inline_template('<%= split.to_a.flatten.inspect %>')
    $opt_split = "  split => ${arr_split}\n"
  }

  if $rename {
    validate_hash($rename)
    $arr_rename = inline_template('<%= rename.to_a.flatten.inspect %>')
    $opt_rename = "  rename => ${arr_rename}\n"
  }

  if $convert {
    validate_hash($convert)
    $arr_convert = inline_template('<%= convert.to_a.flatten.inspect %>')
    $opt_convert = "  convert => ${arr_convert}\n"
  }

  if $join {
    validate_hash($join)
    $arr_join = inline_template('<%= join.to_a.flatten.inspect %>')
    $opt_join = "  join => ${arr_join}\n"
  }

  if $order {
    if ! is_numeric($order) {
      fail("\"${order}\" is not a valid order parameter value")
    }
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/filter_${order}_mutate_${name}":
    ensure  => present,
    content => "filter {\n mutate {\n${opt_add_field}${opt_add_tag}${opt_convert}${opt_exclude_tags}${opt_gsub}${opt_join}${opt_lowercase}${opt_remove}${opt_remove_tag}${opt_rename}${opt_replace}${opt_split}${opt_strip}${opt_tags}${opt_type}${opt_uppercase} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

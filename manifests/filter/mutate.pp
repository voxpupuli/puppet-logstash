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
#   replace all forward slashes with underscore       "fieldname", "/",
#   "_",        # replace backslashes, question marks, hashes, and minuses
#   with       # dot       "fieldname2", "[\\?#-]", "."     ]   } }
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
# [*merge*]
#   merge two fields or arrays or hashes String fields will be converted
#   in array, so  array + string will work  string + string will result in
#   an 2 entry array in dest_field  array and hash will not work  Example:
#   filter {   mutate {       merge =&gt; ["dest_field", "added_field"]
#   } }
#   Value type is hash
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
# [*update*]
#   Update an existing field with a new value. If the field does not
#   exist, then no action will be taken.  Example:  filter {   mutate {
#   update =&gt; [ "sample", "My new message" ]   } }
#   Value type is hash
#   Default value: None
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
#  http://logstash.net/docs/1.1.12/filters/mutate
#
#  Need help? http://logstash.net/docs/1.1.12/learn
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
  $merge        = '',
  $remove       = '',
  $remove_tag   = '',
  $rename       = '',
  $replace      = '',
  $split        = '',
  $strip        = '',
  $tags         = '',
  $type         = '',
  $update       = '',
  $uppercase    = '',
  $order        = 10,
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_mutate_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/mutate/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_mutate_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/mutate/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($add_tag != '') {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if ($uppercase != '') {
    validate_array($uppercase)
    $arr_uppercase = join($uppercase, '\', \'')
    $opt_uppercase = "  uppercase => ['${arr_uppercase}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($gsub != '') {
    validate_array($gsub)
    $arr_gsub = join($gsub, '\', \'')
    $opt_gsub = "  gsub => ['${arr_gsub}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($lowercase != '') {
    validate_array($lowercase)
    $arr_lowercase = join($lowercase, '\', \'')
    $opt_lowercase = "  lowercase => ['${arr_lowercase}']\n"
  }

  if ($strip != '') {
    validate_array($strip)
    $arr_strip = join($strip, '\', \'')
    $opt_strip = "  strip => ['${arr_strip}']\n"
  }

  if ($remove != '') {
    validate_array($remove)
    $arr_remove = join($remove, '\', \'')
    $opt_remove = "  remove => ['${arr_remove}']\n"
  }

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($rename != '') {
    validate_hash($rename)
    $var_rename = $rename
    $arr_rename = inline_template('<%= "["+var_rename.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_rename = "  rename => ${arr_rename}\n"
  }

  if ($replace != '') {
    validate_hash($replace)
    $var_replace = $replace
    $arr_replace = inline_template('<%= "["+var_replace.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_replace = "  replace => ${arr_replace}\n"
  }

  if ($split != '') {
    validate_hash($split)
    $var_split = $split
    $arr_split = inline_template('<%= "["+var_split.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_split = "  split => ${arr_split}\n"
  }

  if ($merge != '') {
    validate_hash($merge)
    $var_merge = $merge
    $arr_merge = inline_template('<%= "["+var_merge.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_merge = "  merge => ${arr_merge}\n"
  }

  if ($join != '') {
    validate_hash($join)
    $var_join = $join
    $arr_join = inline_template('<%= "["+var_join.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_join = "  join => ${arr_join}\n"
  }

  if ($convert != '') {
    validate_hash($convert)
    $var_convert = $convert
    $arr_convert = inline_template('<%= "["+var_convert.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_convert = "  convert => ${arr_convert}\n"
  }

  if ($update != '') {
    validate_hash($update)
    $var_update = $update
    $arr_update = inline_template('<%= "["+var_update.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_update = "  update => ${arr_update}\n"
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
    content => "filter {\n mutate {\n${opt_add_field}${opt_add_tag}${opt_convert}${opt_exclude_tags}${opt_gsub}${opt_join}${opt_lowercase}${opt_merge}${opt_remove}${opt_remove_tag}${opt_rename}${opt_replace}${opt_split}${opt_strip}${opt_tags}${opt_type}${opt_update}${opt_uppercase} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

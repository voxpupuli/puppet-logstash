# == Define: logstash::filter::grep
#
#   Grep filter. Useful for dropping events you don't want to pass, or
#   adding tags or fields to events that match.  Events not matched are
#   dropped. If 'negate' is set to true (defaults false), then matching
#   events are dropped.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   grep {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the grep plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   grep {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*drop*]
#   Drop events that don't match  If this is set to false, no events will
#   be dropped at all. Rather, the requested tags and fields will be added
#   to matching events, and non-matching events will be passed through
#   unchanged.
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*exclude_tags*]
#   Only handle events without any of these tags. Note this check is
#   additional to type and tags.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*match*]
#   A hash of matches of field =&gt; regexp.  If multiple matches are
#   specified, all must match for the grep to be considered successful.
#   Normal regular expressions are supported here.  For example:  filter {
#   grep {     match =&gt; [ "@message", "hello world" ]   } }   The above
#   will drop all events with a message not matching "hello world" as a
#   regular expression.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*negate*]
#   Negate the match. Similar to 'grep -v'  If this is set to true, then
#   any positive matches will result in the event being cancelled and
#   dropped. Non-matching will be allowed through.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   grep {     remove_tag =&gt; [
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
#  http://logstash.net/docs/1.1.12/filters/grep
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::grep (
  $add_field    = '',
  $add_tag      = '',
  $drop         = '',
  $exclude_tags = '',
  $match        = '',
  $negate       = '',
  $remove_tag   = '',
  $tags         = '',
  $type         = '',
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
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_grep_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/grep/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_grep_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/grep/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

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

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($drop != '') {
    validate_bool($drop)
    $opt_drop = "  drop => ${drop}\n"
  }

  if ($negate != '') {
    validate_bool($negate)
    $opt_negate = "  negate => ${negate}\n"
  }

  if ($match != '') {
    validate_hash($match)
    $var_match = $match
    $arr_match = inline_template('<%= "["+var_match.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_match = "  match => ${arr_match}\n"
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
    content => "filter {\n grep {\n${opt_add_field}${opt_add_tag}${opt_drop}${opt_exclude_tags}${opt_match}${opt_negate}${opt_remove_tag}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

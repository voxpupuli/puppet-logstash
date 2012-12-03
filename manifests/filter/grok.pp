# == Define: logstash::filter::grok
#
#   Parse arbitrary text and structure it. Grok is currently the best way
#   in logstash to parse crappy unstructured log data (like syslog or
#   apache logs) into something structured and queryable.  Grok allows you
#   to match text without needing to be a regular expressions ninja.
#   Logstash ships with about 120 patterns by default. You can add your
#   own trivially. (See the patterns_dir setting)
#
#
# === Parameters
#
# [*(?-mix:[A-Za-z0-9_-]+)*] 
#   Any existing field name can be used as a config name here for matching
#   against.  # this config: foo =&gt; "some pattern"  # same as: match
#   =&gt; [ "foo", "some pattern" ]
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*add_field*] 
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   myfilter {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, myfilter will then add
#   field 'sample' with the value above  and the %{@source} piece replaced
#   with that value from the event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*] 
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   myfilter {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*break_on_match*] 
#   Break on first match. The first successful match by grok will result
#   in the filter being finished. If you want grok to try all patterns
#   (maybe you are parsing different things), then set this to false.
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*drop_if_match*] 
#   Drop if matched. Note, this feature may not stay. It is preferable to
#   combine grok + grep filters to do parsing + dropping.  requested in:
#   googlecode/issue/26
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*exclude_tags*] 
#   Only handle events without any of these tags. Note this check is
#   additional to type and tags.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*keep_empty_captures*] 
#   If true, keep empty captures as event fields.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*match*] 
#   A hash of matches of field =&gt; value
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*named_captures_only*] 
#   If true, only store named captures from grok.
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*pattern*] 
#   Specify a pattern to parse with. This will match the '@message' field.
#   If you want to match other fields than @message, use the 'match'
#   setting. Multiple patterns is fine.
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*patterns_dir*] 
#   logstash ships by default with a bunch of patterns, so you don't
#   necessarily need to define this yourself unless you are adding
#   additional patterns.  Pattern files are plain text with format:  NAME
#   PATTERN   For example:  NUMBER \d+
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*remove_tag*] 
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   myfilter {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*singles*] 
#   If true, make single-value fields simply that value, not an array
#   containing that one value.
#   Value type is boolean
#   Default value: false
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
#
# === Examples
#
#
#
#
# === Extra information
#
#  This define is created based on LogStash version 1.1.5
#  Extra information about this filter can be found at:
#  http://logstash.net/docs/1.1.5/filters/grok
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::grok(
  $add_field           = '',
  $add_tag             = '',
  $break_on_match      = '',
  $drop_if_match       = '',
  $exclude_tags        = '',
  $keep_empty_captures = '',
  $match               = '',
  $named_captures_only = '',
  $pattern             = '',
  $patterns_dir        = '',
  $remove_tag          = '',
  $singles             = '',
  $tags                = '',
  $type                = '',
  $order               = 10,
) {

  require logstash::params

  #### Validate parameters
  if $pattern {
    validate_array($pattern)
    $arr_pattern = join($pattern, "', '")
    $opt_pattern = "  pattern => ['${arr_pattern}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $add_tag {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, "', '")
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if $remove_tag {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, "', '")
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if $patterns_dir {
    validate_array($patterns_dir)
    $arr_patterns_dir = join($patterns_dir, "', '")
    $opt_patterns_dir = "  patterns_dir => ['${arr_patterns_dir}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, "', '")
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $drop_if_match {
    validate_bool($drop_if_match)
    $opt_drop_if_match = "  drop_if_match => ${drop_if_match}\n"
  }

  if $break_on_match {
    validate_bool($break_on_match)
    $opt_break_on_match = "  break_on_match => ${break_on_match}\n"
  }

  if $singles {
    validate_bool($singles)
    $opt_singles = "  singles => ${singles}\n"
  }

  if $named_captures_only {
    validate_bool($named_captures_only)
    $opt_named_captures_only = "  named_captures_only => ${named_captures_only}\n"
  }

  if $keep_empty_captures {
    validate_bool($keep_empty_captures)
    $opt_keep_empty_captures = "  keep_empty_captures => ${keep_empty_captures}\n"
  }

  if $match {
    validate_hash($match)
    $arr_match = inline_template('<%= match.to_a.flatten.inspect %>')
    $opt_match = "  match => ${arr_match}\n"
  }

  if $add_field {
    validate_hash($add_field)
    $arr_add_field = inline_template('<%= add_field.to_a.flatten.inspect %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
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

  file { "${logstash::params::configdir}/filter_${order}_grok_${name}":
    ensure  => present,
    content => "filter {\n grok {\n${opt_add_field}${opt_add_tag}${opt_break_on_match}${opt_drop_if_match}${opt_exclude_tags}${opt_keep_empty_captures}${opt_match}${opt_named_captures_only}${opt_pattern}${opt_patterns_dir}${opt_remove_tag}${opt_singles}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

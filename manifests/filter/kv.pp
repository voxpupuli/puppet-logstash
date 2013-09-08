# == Define: logstash::filter::kv
#
#   This filter helps automatically parse messages which are of the
#   'foo=bar' variety.  For example, if you have a log message which
#   contains 'ip=1.2.3.4 error=REFUSED', you can parse those automatically
#   by doing:  filter {   kv { } }   The above will result in a message of
#   "ip=1.2.3.4 error=REFUSED" having the fields:  ip: 1.2.3.4 error:
#   REFUSED This is great for postfix, iptables, and other types of logs
#   that tend towards 'key=value' syntax.  Further, this can often be used
#   to parse query parameters like 'foo=bar&amp;baz=fizz' by setting the
#   field_split to "&amp;"
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   kv {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the kv plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   kv {     add_tag =&gt; [
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
# [*field_split*]
#   A string of characters to use as delimiters for parsing out key-value
#   pairs.  Example with URL Query Strings  Example, to split out the args
#   from a url query string such as
#   '?pin=12345~0&amp;d=123&amp;e=foo@bar.com&amp;oq=bobo&amp;ss=12345':
#   filter {   kv {     field_split =&gt; "&amp;?"    } }   The above
#   splits on both "&amp;" and "?" characters, giving you the following
#   fields:  pin: 12345~0 d: 123 e: foo@bar.com oq: bobo ss: 12345
#   Value type is string
#   Default value: " "
#   This variable is optional
#
# [*fields*]
#   The fields to perform 'key=value' searching on
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*prefix*]
#   A string to prepend to all of the extracted keys  Example, to prepend
#   arg_ to all keys:  filter { kv { prefix =&gt; "arg_" } }
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   kv {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*source*]
#   The fields to perform 'key=value' searching on  Example, to use the
#   @message field:  filter { kv { source =&gt; "@message" } }
#   Value type is string
#   Default value: "@message"
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*target*]
#   The name of the container to put all of the key-value pairs into
#   Example, to place all keys into field kv:  filter { kv { target =&gt;
#   "kv" } }
#   Value type is string
#   Default value: "@fields"
#   This variable is optional
#
# [*trim*]
#   A string of characters to trim from the value. This is useful if your
#   values are wrapped in brackets or are terminated by comma (like
#   postfix logs)  Example, to strip '&lt;' '&gt;' and ',' characters from
#   values:  filter {    kv {      trim =&gt; "&lt;&gt;,"   } }
#   Value type is string
#   Default value: None
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
# [*value_split*]
#   A string of characters to use as delimiters for identifying key-value
#   relations.  Example, to identify key-values such as 'key1:value1
#   key2:value2':  filter { kv { value_split =&gt; ":" } }
#   Value type is string
#   Default value: "="
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
#  http://logstash.net/docs/1.1.12/filters/kv
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::kv (
  $add_field    = '',
  $add_tag      = '',
  $exclude_tags = '',
  $field_split  = '',
  $fields       = '',
  $prefix       = '',
  $remove_tag   = '',
  $source       = '',
  $tags         = '',
  $target       = '',
  $trim         = '',
  $type         = '',
  $value_split  = '',
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
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_kv_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/kv/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_kv_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/kv/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($add_tag != '') {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
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

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
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

  if ($trim != '') {
    validate_string($trim)
    $opt_trim = "  trim => \"${trim}\"\n"
  }

  if ($target != '') {
    validate_string($target)
    $opt_target = "  target => \"${target}\"\n"
  }

  if ($field_split != '') {
    validate_string($field_split)
    $opt_field_split = "  field_split => \"${field_split}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($value_split != '') {
    validate_string($value_split)
    $opt_value_split = "  value_split => \"${value_split}\"\n"
  }

  if ($prefix != '') {
    validate_string($prefix)
    $opt_prefix = "  prefix => \"${prefix}\"\n"
  }

  if ($source != '') {
    validate_string($source)
    $opt_source = "  source => \"${source}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n kv {\n${opt_add_field}${opt_add_tag}${opt_exclude_tags}${opt_field_split}${opt_fields}${opt_prefix}${opt_remove_tag}${opt_source}${opt_tags}${opt_target}${opt_trim}${opt_type}${opt_value_split} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

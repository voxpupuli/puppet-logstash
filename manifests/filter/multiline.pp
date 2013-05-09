# == Define: logstash::filter::multiline
#
#   multiline filter  This filter will collapse multiline messages into a
#   single event.  The multiline filter is for combining multiple events
#   from a single source into the same event.  The original goal of this
#   filter was to allow joining of multi-line messages from files into a
#   single event. For example - joining java exception and stacktrace
#   messages into a single event.  TODO(sissel): Document any issues? The
#   config looks like this:  filter {   multiline {     type =&gt; "type"
#   pattern =&gt; "pattern, a regexp"     negate =&gt; boolean     what
#   =&gt; "previous" or "next"   } }   The 'regexp' should match what you
#   believe to be an indicator that the field is part of a multi-line
#   event  The 'what' must be "previous" or "next" and indicates the
#   relation to the multi-line event.  The 'negate' can be "true" or
#   "false" (defaults false). If true, a message not matching the pattern
#   will constitute a match of the multiline filter and the what will be
#   applied. (vice-versa is also true)  For example, java stack traces are
#   multiline and usually have the message starting at the far-left, then
#   each subsequent line indented. Do this:  filter {   multiline {
#   type =&gt; "somefiletype"     pattern =&gt; "^\s"     what =&gt;
#   "previous"   } }   This says that any line starting with whitespace
#   belongs to the previous line.  Another example is C line continuations
#   (backslash). Here's how to do that:  filter {   multiline {     type
#   =&gt; "somefiletype "     pattern =&gt; "\\$"     what =&gt; "next"
#   } }
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   multiline {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the multiline plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   multiline {     add_tag =&gt; [
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
# [*negate*]
#   Negate the regexp pattern ('if not matched')
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*pattern*]
#   The regular expression to match
#   Value type is string
#   Default value: None
#   This variable is required
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
#   syntax. Example:  filter {   multiline {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*stream_identity*]
#   The stream identity is how the multiline filter determines which
#   stream an event belongs. This is generally used for differentiating,
#   say, events coming from multiple files in the same file input, or
#   multiple connections coming from a tcp input.  The default value here
#   is usually what you want, but there are some cases where you want to
#   change it. One such example is if you are using a tcp input with only
#   one client connecting at any time. If that client reconnects (due to
#   error or client restart), then logstash will identify the new
#   connection as a new stream and break any multiline goodness that may
#   have occurred between the old and new connection. To solve this use
#   case, you can use "%{@source_host}.%{@type}" instead.
#   Value type is string
#   Default value: "%{@source}.%{@type}"
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
# [*what*]
#   If the pattern matched, does event belong to the next or previous
#   event?
#   Value can be any of: "previous", "next"
#   Default value: None
#   This variable is required
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
#  http://logstash.net/docs/1.1.12/filters/multiline
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::multiline (
  $pattern,
  $what,
  $remove_tag      = '',
  $negate          = '',
  $add_field       = '',
  $patterns_dir    = '',
  $exclude_tags    = '',
  $stream_identity = '',
  $tags            = '',
  $type            = '',
  $add_tag         = '',
  $order           = 10,
  $instances       = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_multiline_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/multiline/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_multiline_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/multiline/${name}"

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

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($patterns_dir != '') {
    validate_array($patterns_dir)
    $arr_patterns_dir = join($patterns_dir, '\', \'')
    $opt_patterns_dir = "  patterns_dir => ['${arr_patterns_dir}']\n"
  }

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($negate != '') {
    validate_bool($negate)
    $opt_negate = "  negate => ${negate}\n"
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

  if ($what != '') {
    if ! ($what in ['previous', 'next']) {
      fail("\"${what}\" is not a valid what parameter value")
    } else {
      $opt_what = "  what => \"${what}\"\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($stream_identity != '') {
    validate_string($stream_identity)
    $opt_stream_identity = "  stream_identity => \"${stream_identity}\"\n"
  }

  if ($pattern != '') {
    validate_string($pattern)
    $opt_pattern = "  pattern => \"${pattern}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n multiline {\n${opt_add_field}${opt_add_tag}${opt_exclude_tags}${opt_negate}${opt_pattern}${opt_patterns_dir}${opt_remove_tag}${opt_stream_identity}${opt_tags}${opt_type}${opt_what} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

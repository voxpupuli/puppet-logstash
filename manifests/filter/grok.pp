# == Define: logstash::filter::grok
#
#   Parse arbitrary text and structure it.  Grok is currently the best way
#   in logstash to parse crappy unstructured log data into something
#   structured and queryable.  This tool is perfect for syslog logs,
#   apache and other webserver logs, mysql logs, and in general, any log
#   format that is generally written for humans and not computer
#   consumption.  Logstash ships with about 120 patterns by default. You
#   can find them here:
#   https://github.com/logstash/logstash/tree/v1.1.12/patterns. You can
#   add your own trivially. (See the patterns_dir setting)  If you need
#   help building patterns to match your logs, you will find the
#   http://grokdebug.herokuapp.com too quite useful!  Grok Basics  Grok
#   works by using combining text patterns into something that matches
#   your logs.  The syntax for a grok pattern is %{SYNTAX:SEMANTIC}  The
#   SYNTAX is the name of the pattern that will match your text. For
#   example, "3.44" will be matched by the NUMBER pattern and "55.3.244.1"
#   will be matched by the IP pattern. The syntax is how you match.  The
#   SEMANTIC is the identifier you give to the piece of text being
#   matched. For example, "3.44" could be the duration of an event, so you
#   could call it simply 'duration'. Further, a string "55.3.244.1" might
#   identify the client making a request.  Optionally you can add a data
#   type conversion to your grok pattern. By default all semantics are
#   saved as strings. If you wish to convert a semnatic's data type, for
#   example change a string to an integer then suffix it with the target
#   data type. For example ${NUMBER:num:int} which converts the 'num'
#   semantic from a string to an integer. Currently the only supporting
#   conversions are int and float.  Example  With that idea of a syntax
#   and semantic, we can pull out useful fields from a sample log like
#   this fictional http request log:  55.3.244.1 GET /index.html 15824
#   0.043   The pattern for this could be:  %{IP:client} %{WORD:method}
#   %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}   A more
#   realistic example, let's read these logs from a file:  input {   file
#   {     path =&gt; "/var/log/http.log"     type =&gt; "examplehttp"   }
#   } filter {   grok {     type =&gt; "examplehttp"     pattern =&gt;
#   "%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes}
#   %{NUMBER:duration}"   } }   After the grok filter, the event will have
#   a few extra fields in it:  client: 55.3.244.1 method: GET request:
#   /index.html bytes: 15824 duration: 0.043 Regular Expressions  Grok
#   sits on top of regular expressions, so any regular expressions are
#   valid in grok as well. The regular expression library is Oniguruma,
#   and you can see the full supported regexp syntax on the Onigiruma site
#   Custom Patterns  Sometimes logstash doesn't have a pattern you need.
#   For this, you have a few options.  First, you can use the Oniguruma
#   syntax for 'named capture' which will let you match a piece of text
#   and save it as a field:  (?&lt;field_name&gt;the pattern here)   For
#   example, postfix logs have a 'queue id' that is an 11-character
#   hexadecimal value. I can capture that easily like this:
#   (?&lt;queue_id&gt;[0-9A-F]{11})   Alternately, you can create a custom
#   patterns file.  Create a directory called patterns with a file in it
#   called extra (the file name doesn't matter, but name it meaningfully
#   for yourself) In that file, write the pattern you need as the pattern
#   name, a space, then the regexp for that pattern. For example, doing
#   the postfix queue id example as above:  # in ./patterns/postfix
#   POSTFIX_QUEUEID [0-9A-F]{11}   Then use the patterns_dir setting in
#   this plugin to tell logstash where your custom patterns directory is.
#   Here's a full example with a sample log:  Jan  1 06:25:43 mailserver14
#   postfix/cleanup[21403]: BEF25A72965:
#   message-id=&lt;20130101142543.5828399CCAF@mailserver14.example.com&gt;
#   filter {   grok {     patterns_dir =&gt; "./patterns"     pattern
#   =&gt; "%{SYSLOGBASE} %{POSTFIX_QUEUEID:queue_id}:
#   %{GREEDYDATA:message}"   } }   The above will match and result in the
#   following fields:  timestamp: Jan  1 06:25:43 logsource: mailserver14
#   program: postfix/cleanup pid: 21403 queue_id: BEF25A72965 The
#   timestamp, logsource, program, and pid fields come from the SYSLOGBASE
#   pattern which itself is defined by other patterns.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   grok {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the grok plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   grok {     add_tag =&gt; [
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
#   A hash of matches of field =&gt; value  For example:  filter {   grok
#   {     match =&gt; [ "@message", "Duration: %{NUMBER:duration} ]   } }
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
#   syntax. Example:  filter {   grok {     remove_tag =&gt; [
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
# [*tag_on_failure*]
#   If true, ensure the '_grokparsefailure' tag is present when there has
#   been no successful match
#   Value type is array
#   Default value: ["_grokparsefailure"]
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
#  http://logstash.net/docs/1.1.12/filters/grok
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::grok (
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
  $tag_on_failure      = '',
  $tags                = '',
  $type                = '',
  $order               = 10,
  $instances           = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_grok_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/grok/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_grok_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/grok/${name}"

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

  if ($tag_on_failure != '') {
    validate_array($tag_on_failure)
    $arr_tag_on_failure = join($tag_on_failure, '\', \'')
    $opt_tag_on_failure = "  tag_on_failure => ['${arr_tag_on_failure}']\n"
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

  if ($patterns_dir != '') {
    validate_array($patterns_dir)
    $arr_patterns_dir = join($patterns_dir, '\', \'')
    $opt_patterns_dir = "  patterns_dir => ['${arr_patterns_dir}']\n"
  }

  if ($pattern != '') {
    validate_array($pattern)
    $arr_pattern = join($pattern, '\', \'')
    $opt_pattern = "  pattern => ['${arr_pattern}']\n"
  }

  if ($named_captures_only != '') {
    validate_bool($named_captures_only)
    $opt_named_captures_only = "  named_captures_only => ${named_captures_only}\n"
  }

  if ($singles != '') {
    validate_bool($singles)
    $opt_singles = "  singles => ${singles}\n"
  }

  if ($keep_empty_captures != '') {
    validate_bool($keep_empty_captures)
    $opt_keep_empty_captures = "  keep_empty_captures => ${keep_empty_captures}\n"
  }

  if ($drop_if_match != '') {
    validate_bool($drop_if_match)
    $opt_drop_if_match = "  drop_if_match => ${drop_if_match}\n"
  }

  if ($break_on_match != '') {
    validate_bool($break_on_match)
    $opt_break_on_match = "  break_on_match => ${break_on_match}\n"
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
    content => "filter {\n grok {\n${opt_add_field}${opt_add_tag}${opt_break_on_match}${opt_drop_if_match}${opt_exclude_tags}${opt_keep_empty_captures}${opt_match}${opt_named_captures_only}${opt_pattern}${opt_patterns_dir}${opt_remove_tag}${opt_singles}${opt_tag_on_failure}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

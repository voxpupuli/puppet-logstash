# == Define: logstash::filter::sleep
#
#   Sleep a given amount of time. This will cause logstash to stall for
#   the given amount of time. This is useful for rate limiting, etc.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   sleep {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the sleep plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   sleep {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*every*]
#   Sleep on every N'th. This option is ignored in replay mode.  Example:
#   filter {   sleep {     time =&gt; "1"   # Sleep 1 second      every
#   =&gt; 10   # on every 10th event   } }
#   Value type is string
#   Default value: 1
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
#   syntax. Example:  filter {   sleep {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*replay*]
#   Enable replay mode.  Replay mode tries to sleep based on timestamps in
#   each event.  The amount of time to sleep is computed by subtracting
#   the previous event's timestamp from the current event's timestamp.
#   This helps you replay events in the same timeline as original.  If you
#   specify a time setting as well, this filter will use the time value as
#   a speed modifier. For example, a time value of 2 will replay at double
#   speed, while a value of 0.25 will replay at 1/4th speed.  For example:
#   filter {   sleep {     time =&gt; 2     replay =&gt; true   } }   The
#   above will sleep in such a way that it will perform replay 2-times
#   faster than the original time speed.
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
# [*time*]
#   The length of time to sleep, in seconds, for every event.  This can be
#   a number (eg, 0.5), or a string (eg, "%{foo}") The second form (string
#   with a field value) is useful if you have an attribute of your event
#   that you want to use to indicate the amount of time to sleep.
#   Example:  filter {   sleep {     # Sleep 1 second for every event.
#   time =&gt; "1"   } }
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
#  http://logstash.net/docs/1.1.12/filters/sleep
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::sleep (
  $add_field    = '',
  $add_tag      = '',
  $every        = '',
  $exclude_tags = '',
  $remove_tag   = '',
  $replay       = '',
  $tags         = '',
  $time         = '',
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
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_sleep_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/sleep/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_sleep_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/sleep/${name}"

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

  if ($replay != '') {
    validate_bool($replay)
    $opt_replay = "  replay => ${replay}\n"
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

  if ($time != '') {
    validate_string($time)
    $opt_time = "  time => \"${time}\"\n"
  }

  if ($every != '') {
    validate_string($every)
    $opt_every = "  every => \"${every}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n sleep {\n${opt_add_field}${opt_add_tag}${opt_every}${opt_exclude_tags}${opt_remove_tag}${opt_replay}${opt_tags}${opt_time}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

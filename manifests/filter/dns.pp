# == Define: logstash::filter::dns
#
#   DNS Filter  This filter will resolve any IP addresses from a field of
#   your choosing.  The DNS filter performs a lookup (either an A
#   record/CNAME record lookup or a reverse lookup at the PTR record) on
#   records specified under the "reverse" and "resolve" arrays.  The
#   config should look like this:  filter {   dns {     type =&gt; 'type'
#   reverse =&gt; [ "@source_host", "field_with_address" ]     resolve
#   =&gt; [ "field_with_fqdn" ]     action =&gt; "replace"   } }
#   Caveats: at the moment, there's no way to tune the timeout with the
#   'resolv' core library.  It does seem to be fixed in here:
#   http://redmine.ruby-lang.org/issues/5100  but isn't currently in
#   JRuby.
#
#
# === Parameters
#
# [*action*]
#   Determine what action to do: append or replace the values in the
#   fields specified under "reverse" and "resolve."
#   Value can be any of: "append", "replace"
#   Default value: "append"
#   This variable is optional
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   dns {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the dns plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   dns {     add_tag =&gt; [
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
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   dns {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*resolve*]
#   Forward resolve one or more fields.
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*reverse*]
#   Reverse resolve one or more fields.
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
#  http://logstash.net/docs/1.1.12/filters/dns
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::dns (
  $action       = '',
  $add_field    = '',
  $add_tag      = '',
  $exclude_tags = '',
  $remove_tag   = '',
  $resolve      = '',
  $reverse      = '',
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
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_dns_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/dns/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_dns_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/dns/${name}"

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

  if ($reverse != '') {
    validate_array($reverse)
    $arr_reverse = join($reverse, '\', \'')
    $opt_reverse = "  reverse => ['${arr_reverse}']\n"
  }

  if ($resolve != '') {
    validate_array($resolve)
    $arr_resolve = join($resolve, '\', \'')
    $opt_resolve = "  resolve => ['${arr_resolve}']\n"
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

  if ($action != '') {
    if ! ($action in ['append', 'replace']) {
      fail("\"${action}\" is not a valid action parameter value")
    } else {
      $opt_action = "  action => \"${action}\"\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n dns {\n${opt_action}${opt_add_field}${opt_add_tag}${opt_exclude_tags}${opt_remove_tag}${opt_resolve}${opt_reverse}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

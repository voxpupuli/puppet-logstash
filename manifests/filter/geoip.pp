# == Define: logstash::filter::geoip
#
#   Add GeoIP fields from Maxmind database  GeoIP filter, adds information
#   about geographical location of IP addresses. This filter uses Maxmind
#   GeoIP databases, have a look at https://www.maxmind.com/app/geolite
#   Logstash releases ship with the GeoLiteCity database made available
#   from Maxmind with a CCA-ShareAlike 3.0 license. For more details on
#   geolite, see http://www.maxmind.com/en/geolite.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   geoip {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the geoip plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   geoip {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*database*]
#   GeoIP database file to use, Country, City, ASN, ISP and organization
#   databases are supported  If not specified, this will default to the
#   GeoLiteCity database that ships with logstash.
#   Value type is string
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
# [*field*]
#   The field containing IP address, hostname is also OK. If this field is
#   an array, only the first value will be used.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   geoip {     remove_tag =&gt; [
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
#  http://logstash.net/docs/1.1.9/filters/geoip
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::geoip (
  $field,
  $add_field    = '',
  $database     = '',
  $exclude_tags = '',
  $add_tag      = '',
  $remove_tag   = '',
  $tags         = '',
  $type         = '',
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

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
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

  if $database {
    validate_string($database)
    $opt_database = "  database => \"${database}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $field {
    validate_string($field)
    $opt_field = "  field => \"${field}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/filter_${order}_geoip_${name}":
    ensure  => present,
    content => "filter {\n geoip {\n${opt_add_field}${opt_add_tag}${opt_database}${opt_exclude_tags}${opt_field}${opt_remove_tag}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

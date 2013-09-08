# == Define: logstash::filter::xml
#
#   XML filter. Takes a field that contains XML and expands it into an
#   actual datastructure.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   xml {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the xml plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   xml {     add_tag =&gt; [
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
#   syntax. Example:  filter {   xml {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*source*]
#   Config for xml to hash is:  source =&gt; source_field   For example,
#   if you have the whole xml document in your @message field:  filter {
#   xml {     source =&gt; "@message"   } }   The above would parse the
#   xml from the @message field
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*store_xml*]
#   By default the filter will store the whole parsed xml in the
#   destination field as described above. Setting this to false will
#   prevent that.
#   Value type is boolean
#   Default value: true
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
#   Define target for placing the data  for example if you want the data
#   to be put in the 'doc' field:  filter {   xml {     target =&gt; "doc"
#   } }   XML in the value of the source field will be expanded into a
#   datastructure in the "target" field. Note: if the "target" field
#   already exists, it will be overridden Required
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
# [*xpath*]
#   xpath will additionally select string values (.to_s on whatever is
#   selected) from parsed XML (using each source field defined using the
#   method above) and place those values in the destination fields.
#   Configuration:  xpath =&gt; [ "xpath-syntax", "destination-field" ]
#   Values returned by XPath parsring from xpath-synatx will be put in the
#   destination field. Multiple values returned will be pushed onto the
#   destination field as an array. As such, multiple matches across
#   multiple source fields will produce duplicate entries in the field
#   More on xpath: http://www.w3schools.com/xpath/  The xpath functions
#   are particularly powerful:
#   http://www.w3schools.com/xpath/xpath_functions.asp
#   Value type is hash
#   Default value: {}
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
#  http://logstash.net/docs/1.1.12/filters/xml
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::xml (
  $add_field    = '',
  $add_tag      = '',
  $exclude_tags = '',
  $remove_tag   = '',
  $source       = '',
  $store_xml    = '',
  $tags         = '',
  $target       = '',
  $type         = '',
  $xpath        = '',
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
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_xml_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/xml/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_xml_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/xml/${name}"

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

  if ($store_xml != '') {
    validate_bool($store_xml)
    $opt_store_xml = "  store_xml => ${store_xml}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if ($xpath != '') {
    validate_hash($xpath)
    $var_xpath = $xpath
    $arr_xpath = inline_template('<%= "["+var_xpath.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_xpath = "  xpath => ${arr_xpath}\n"
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

  if ($target != '') {
    validate_string($target)
    $opt_target = "  target => \"${target}\"\n"
  }

  if ($source != '') {
    validate_string($source)
    $opt_source = "  source => \"${source}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n xml {\n${opt_add_field}${opt_add_tag}${opt_exclude_tags}${opt_remove_tag}${opt_source}${opt_store_xml}${opt_tags}${opt_target}${opt_type}${opt_xpath} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

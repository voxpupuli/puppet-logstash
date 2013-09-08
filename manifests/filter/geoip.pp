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
#   Value type is path
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
# [*fields*]
#   Array of geoip fields that we want to be included in our event.
#   Possible fields depend on the database type. By default, all geoip
#   fields are included in the event.  For the built in GeoLiteCity
#   database, the following are available: cityname, continentcode,
#   countrycode2, countrycode3, countryname, dmacode, ip, latitude,
#   longitude, postalcode, regionname, timezone
#   Value type is array
#   Default value: None
#   This variable is optional
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
# [*source*]
#   The field containing IP address, hostname is also OK. If this field is
#   an array, only the first value will be used.
#   Value type is string
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
#  http://logstash.net/docs/1.1.12/filters/geoip
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::geoip (
  $add_field    = '',
  $add_tag      = '',
  $database     = '',
  $exclude_tags = '',
  $fields       = '',
  $remove_tag   = '',
  $source       = '',
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
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_geoip_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/geoip/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_geoip_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/geoip/${name}"

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

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
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

  if ($database != '') {
    if $database =~ /^puppet\:\/\// {

      validate_re($database, '\Apuppet:\/\/')

      $filenameArray_database = split($database, '/')
      $basefilename_database = $filenameArray_database[-1]

      $opt_database = "  database => \"${filesdir}/${basefilename_database}\"\n"

      file { "${filesdir}/${basefilename_database}":
        source  => $database,
        mode    => '0440',
        require => File[$filesdir]
      }
    } else {
      $opt_database = "  database => \"${database}\"\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($source != '') {
    validate_string($source)
    $opt_source = "  source => \"${source}\"\n"
  }


  #### Create the directory where we place the files
  exec { "create_files_dir_filter_geoip_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${filesdir}",
    creates => $filesdir
  }

  #### Manage the files directory
  file { $filesdir:
    ensure  => directory,
    mode    => '0640',
    purge   => true,
    recurse => true,
    require => Exec["create_files_dir_filter_geoip_${name}"],
    notify  => Service[$services]
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n geoip {\n${opt_add_field}${opt_add_tag}${opt_database}${opt_exclude_tags}${opt_fields}${opt_remove_tag}${opt_source}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

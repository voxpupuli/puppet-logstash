# == Define: logstash::output::gemfire
#
#   Push events to a GemFire region.  GemFire is an object database.  To
#   use this plugin you need to add gemfire.jar to your CLASSPATH; using
#   format=json requires jackson.jar too.  Note: this plugin has only been
#   tested with GemFire 7.0.
#
#
# === Parameters
#
# [*cache_name*]
#   Your client cache name
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*cache_xml_file*]
#   The path to a GemFire client cache XML file.  Example:
#   &lt;client-cache&gt;    &lt;pool name="client-pool"&gt;
#   &lt;locator host="localhost" port="31331"/&gt;    &lt;/pool&gt;
#   &lt;region name="Logstash"&gt;        &lt;region-attributes
#   refid="CACHING_PROXY" pool-name="client-pool" &gt;
#   &lt;/region-attributes&gt;    &lt;/region&gt;  &lt;/client-cache&gt;
#   Value type is string
#   Default value: nil
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
#   Only handle events with all of these fields. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*key_format*]
#   A sprintf format to use when building keys
#   Value type is string
#   Default value: "%{@source}-%{@timestamp}"
#   This variable is optional
#
# [*region_name*]
#   The region name
#   Value type is string
#   Default value: "Logstash"
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
#   The type to act on. If a type is given, then this output will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
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
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.12/outputs/gemfire
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::gemfire (
  $cache_name     = '',
  $cache_xml_file = '',
  $exclude_tags   = '',
  $fields         = '',
  $key_format     = '',
  $region_name    = '',
  $tags           = '',
  $type           = '',
  $instances      = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_gemfire_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/gemfire/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_gemfire_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/gemfire/${name}"

  }

  #### Validate parameters

  validate_array($instances)

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

  if ($key_format != '') {
    validate_string($key_format)
    $opt_key_format = "  key_format => \"${key_format}\"\n"
  }

  if ($region_name != '') {
    validate_string($region_name)
    $opt_region_name = "  region_name => \"${region_name}\"\n"
  }

  if ($cache_xml_file != '') {
    validate_string($cache_xml_file)
    $opt_cache_xml_file = "  cache_xml_file => \"${cache_xml_file}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($cache_name != '') {
    validate_string($cache_name)
    $opt_cache_name = "  cache_name => \"${cache_name}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n gemfire {\n${opt_cache_name}${opt_cache_xml_file}${opt_exclude_tags}${opt_fields}${opt_key_format}${opt_region_name}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

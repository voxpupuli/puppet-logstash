# == Define: logstash::input::gemfire
#
#   Push events to a GemFire region.  GemFire is an object database.  To
#   use this plugin you need to add gemfire.jar to your CLASSPATH. Using
#   format=json requires jackson.jar too; use of continuous queries
#   requires antlr.jar.  Note: this plugin has only been tested with
#   GemFire 7.0.
#
#
# === Parameters
#
# [*add_field*]
#   Add a field to an event
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*cache_name*]
#   Your client cache name
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*cache_xml_file*]
#   The path to a GemFire client cache XML file.  Example:
#   &lt;client-cache&gt;    &lt;pool name="client-pool"
#   subscription-enabled="true" subscription-redundancy="1"&gt;
#   &lt;locator host="localhost" port="31331"/&gt;    &lt;/pool&gt;
#   &lt;region name="Logstash"&gt;        &lt;region-attributes
#   refid="CACHING_PROXY" pool-name="client-pool" &gt;
#   &lt;/region-attributes&gt;    &lt;/region&gt;  &lt;/client-cache&gt;
#   Value type is string
#   Default value: nil
#   This variable is optional
#
# [*codec*]
#   A codec value.  It is recommended that you use the logstash_codec function
#   to derive this variable. Example: logstash_codec('graphite', {'charset' => 'UTF-8'})
#   but you could just pass a string, Example: "graphite{ charset => 'UTF-8' }"
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*conditional*]
#   Surrounds the rule with a conditional.  It is recommended that you use the
#   logstash_conditional function, Example: logstash_conditional('[type] == "apache"')
#   or, Example: logstash_conditional(['[loglevel] == "ERROR"','[deployment] == "production"'], 'or')
#   but you could just pass a string, Example: '[loglevel] == "ERROR" or [deployment] == "production"'
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*debug*]
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*interest_regexp*]
#   A regexp to use when registering interest for cache events. Ignored if
#   a :query is specified.
#   Value type is string
#   Default value: ".*"
#   This variable is optional
#
# [*query*]
#   A query to run as a GemFire "continuous query"; if specified it takes
#   precedence over :interest_regexp which will be ignore.  Important: use
#   of continuous queries requires subscriptions to be enabled on the
#   client pool.
#   Value type is string
#   Default value: nil
#   This variable is optional
#
# [*region_name*]
#   The region name
#   Value type is string
#   Default value: "Logstash"
#   This variable is optional
#
# [*serialization*]
#   How the message is serialized in the cache. Can be one of "json" or
#   "plain"; default is plain
#   Value type is string
#   Default value: nil
#   This variable is optional
#
# [*tags*]
#   Add any number of arbitrary tags to your event.  This can help with
#   processing later.
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*threads*]
#   Set this to the number of threads you want this input to spawn. This
#   is the same as declaring the input multiple times
#   Value type is number
#   Default value: 1
#   This variable is optional
#
# [*type*]
#   Label this input with a type. Types are used mainly for filter
#   activation.  If you create an input with type "foobar", then only
#   filters which also have type "foobar" will act on them.  The type is
#   also stored as part of the event itself, so you can also use the type
#   to search for in the web interface.  If you try to set a type on an
#   event that already has one (for example when you send an event from a
#   shipper to an indexer) then a new input will not override the existing
#   type. A type set at the shipper stays with that event for its life
#   even when sent to another LogStash server.
#   Value type is string
#   Default value: None
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
#  This define is created based on LogStash version 1.2.2
#  Extra information about this input can be found at:
#  http://logstash.net/docs/1.2.2/inputs/gemfire
#
#  Need help? http://logstash.net/docs/1.2.2/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
# === Contributors
#
# * Luke Chavers <mailto:vmadman@gmail.com> - Added Initial Logstash 1.2.x Support
#
define logstash::input::gemfire (
  $type,
  $cache_xml_file  = '',
  $charset         = '',
  $debug           = '',
  $interest_regexp = '',
  $codec           = '',
  $conditional     = '',
  $cache_name      = '',
  $query           = '',
  $region_name     = '',
  $serialization   = '',
  $tags            = '',
  $threads         = '',
  $add_field       = '',
  $instances       = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_gemfire_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/gemfire/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_gemfire_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/gemfire/${name}"

  }

  #### Validate parameters

  if ($conditional != '') {
    validate_string($conditional)
    $opt_indent = "   "
    $opt_cond_start = " ${conditional}\n "
    $opt_cond_end = "  }\n "
  } else {
    $opt_indent = "  "
    $opt_cond_end = " "
  }

  if ($codec != '') {
    validate_string($codec)
    $opt_codec = "${opt_indent}codec => ${codec}\n"
  }

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "${opt_indent}tags => ['${arr_tags}']\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "${opt_indent}debug => ${debug}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "${opt_indent}add_field => ${arr_add_field}\n"
  }

  if ($threads != '') {
    if ! is_numeric($threads) {
      fail("\"${threads}\" is not a valid threads parameter value")
    } else {
      $opt_threads = "${opt_indent}threads => ${threads}\n"
    }
  }

  if ($region_name != '') {
    validate_string($region_name)
    $opt_region_name = "${opt_indent}region_name => \"${region_name}\"\n"
  }

  if ($cache_xml_file != '') {
    validate_string($cache_xml_file)
    $opt_cache_xml_file = "${opt_indent}cache_xml_file => \"${cache_xml_file}\"\n"
  }

  if ($query != '') {
    validate_string($query)
    $opt_query = "${opt_indent}query => \"${query}\"\n"
  }

  if ($message_format != '') {
    validate_string($message_format)
    $opt_message_format = "${opt_indent}message_format => \"${message_format}\"\n"
  }

  if ($serialization != '') {
    validate_string($serialization)
    $opt_serialization = "${opt_indent}serialization => \"${serialization}\"\n"
  }

  if ($cache_name != '') {
    validate_string($cache_name)
    $opt_cache_name = "${opt_indent}cache_name => \"${cache_name}\"\n"
  }

  if ($interest_regexp != '') {
    validate_string($interest_regexp)
    $opt_interest_regexp = "${opt_indent}interest_regexp => \"${interest_regexp}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n${opt_cond_start} gemfire {\n${opt_add_field}${opt_cache_name}${opt_cache_xml_file}${opt_debug}${opt_interest_regexp}${opt_codec}${opt_query}${opt_region_name}${opt_serialization}${opt_tags}${opt_threads}${opt_type}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

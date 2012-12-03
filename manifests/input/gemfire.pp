# == Define: logstash::input::gemfire
#
#   This is the threadable class for logstash inputs. Use this class in
#   your inputs if it can support multiple threads
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
# [*debug*] 
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*format*] 
#   The format of input data (plain, json, json_event)
#   Value can be any of: "plain", "json", "json_event"
#   Default value: None
#   This variable is optional
#
# [*interest_regexp*] 
#   A regexp to use when registering interest for cache events. Ignored if
#   a :query is specified.
#   Value type is string
#   Default value: ".*"
#   This variable is optional
#
# [*message_format*] 
#   If format is "json", an event sprintf string to build what the display
#   @message should be given (defaults to the raw JSON). sprintf format
#   strings look like %{fieldname} or %{@metadata}.  If format is
#   "json_event", ALL fields except for @type are expected to be present.
#   Not receiving all fields will cause unexpected results.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*name*] 
#   Your client cache name
#   Value type is string
#   Default value: "logstash"
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
#   to search for in the web interface.
#   Value type is string
#   Default value: None
#   This variable is required
#
#
#
# === Examples
#
#
#
#
# === Extra information
#
#  This define is created based on LogStash version 1.1.5
#  Extra information about this input can be found at:
#  http://logstash.net/docs/1.1.5/inputs/gemfire
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::gemfire(
  $type,
  $name            = '',
  $debug           = '',
  $format          = '',
  $interest_regexp = '',
  $message_format  = '',
  $cache_xml_file  = '',
  $query           = '',
  $region_name     = '',
  $serialization   = '',
  $tags            = '',
  $threads         = '',
  $add_field       = '',
) {

  require logstash::params

  #### Validate parameters
  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $add_field {
    validate_hash($add_field)
    $arr_add_field = inline_template('<%= add_field.to_a.flatten.inspect %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if $threads {
    if ! is_numeric($threads) {
      fail("\"${threads}\" is not a valid threads parameter value")
    }
  }

  if $format {
    if ! ($format in ['plain', 'json', 'json_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if $name { 
    validate_string($name)
    $opt_name = "  name => \"${name}\"\n"
  }

  if $message_format { 
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $query { 
    validate_string($query)
    $opt_query = "  query => \"${query}\"\n"
  }

  if $region_name { 
    validate_string($region_name)
    $opt_region_name = "  region_name => \"${region_name}\"\n"
  }

  if $serialization { 
    validate_string($serialization)
    $opt_serialization = "  serialization => \"${serialization}\"\n"
  }

  if $interest_regexp { 
    validate_string($interest_regexp)
    $opt_interest_regexp = "  interest_regexp => \"${interest_regexp}\"\n"
  }

  if $cache_xml_file { 
    validate_string($cache_xml_file)
    $opt_cache_xml_file = "  cache_xml_file => \"${cache_xml_file}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/input_gemfire_${name}":
    ensure  => present,
    content => "input {\n gemfire {\n${opt_add_field}${opt_cache_xml_file}${opt_debug}${opt_format}${opt_interest_regexp}${opt_message_format}${opt_name}${opt_query}${opt_region_name}${opt_serialization}${opt_tags}${opt_threads}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

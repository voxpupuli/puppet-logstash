# == Define: logstash::input::redis
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
# [*data_type*] 
#   Either list or channel.  If redis_type is list, then we will BLPOP the
#   key.  If redis_type is channel, then we will SUBSCRIBE to the key. If
#   redis_type is pattern_channel, then we will PSUBSCRIBE to the key.
#   TODO: change required to true
#   Value can be any of: "list", "channel", "pattern_channel"
#   Default value: None
#   This variable is optional
#
# [*db*] 
#   The redis database number.
#   Value type is number
#   Default value: 0
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
# [*host*] 
#   The hostname of your redis server.
#   Value type is string
#   Default value: "127.0.0.1"
#   This variable is optional
#
# [*key*] 
#   The name of a redis list or channel. TODO: change required to true
#   Value type is string
#   Default value: None
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
# [*password*] 
#   Password to authenticate with. There is no authentication by default.
#   Value type is password
#   Default value: None
#   This variable is optional
#
# [*port*] 
#   The port to connect on.
#   Value type is number
#   Default value: 6379
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
# [*timeout*] 
#   Initial connection timeout in seconds.
#   Value type is number
#   Default value: 5
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
#  http://logstash.net/docs/1.1.5/inputs/redis
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::redis(
  $type,
  $db             = '',
  $debug          = '',
  $format         = '',
  $host           = '',
  $key            = '',
  $message_format = '',
  $data_type      = '',
  $password       = '',
  $port           = '',
  $tags           = '',
  $threads        = '',
  $timeout        = '',
  $add_field      = '',
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

  if $db {
    if ! is_numeric($db) {
      fail("\"${db}\" is not a valid db parameter value")
    }
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    }
  }

  if $threads {
    if ! is_numeric($threads) {
      fail("\"${threads}\" is not a valid threads parameter value")
    }
  }

  if $timeout {
    if ! is_numeric($timeout) {
      fail("\"${timeout}\" is not a valid timeout parameter value")
    }
  }

  if $format {
    if ! ($format in ['plain', 'json', 'json_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if $data_type {
    if ! ($data_type in ['list', 'channel', 'pattern_channel']) {
      fail("\"${data_type}\" is not a valid data_type parameter value")
    } else {
      $opt_data_type = "  data_type => \"${data_type}\"\n"
    }
  }

  if $password { 
    validate_string($password)
    $opt_password = "  password => \"${password}\"\n"
  }

  if $message_format { 
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $key { 
    validate_string($key)
    $opt_key = "  key => \"${key}\"\n"
  }

  if $host { 
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/input_redis_${name}":
    ensure  => present,
    content => "input {\n redis {\n${opt_add_field}${opt_data_type}${opt_db}${opt_debug}${opt_format}${opt_host}${opt_key}${opt_message_format}${opt_password}${opt_port}${opt_tags}${opt_threads}${opt_timeout}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

# == Define: logstash::input::amqp
#
#   This is the threadable class for logstash inputs. Use this class in
#   your inputs if it can support multiple threads
#
#
# === Parameters
#
# [*ack*] 
#   Enable message acknowledgement
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*add_field*] 
#   Add a field to an event
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*arguments*] 
#   Your amqp broker's custom arguments. For mirrored queues in RabbitMQ:
#   [ "x-ha-policy", "all" ]
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*auto_delete*] 
#   Should the queue be deleted on the broker when the last consumer
#   disconnects? Set this option to 'false' if you want the queue to
#   remain on the broker, queueing up messages until a consumer comes
#   along to consume them.
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*debug*] 
#   Enable or disable debugging
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*durable*] 
#   Is this queue durable? (aka; Should it survive a broker restart?)
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*exchange*] 
#   The name of the exchange to bind the queue. This is analogous to the
#   'amqp output' config 'name'
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*exclusive*] 
#   Is the queue exclusive? (aka: Will other clients connect to this named
#   queue?)
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*format*] 
#   The format of input data (plain, json, json_event)
#   Value can be any of: "plain", "json", "json_event"
#   Default value: None
#   This variable is optional
#
# [*host*] 
#   Your amqp server address
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*key*] 
#   The routing key to use. This is only valid for direct or fanout
#   exchanges  Routing keys are ignored on topic exchanges. Wildcards are
#   not valid on direct exchanges.
#   Value type is string
#   Default value: "logstash"
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
#   The name of the queue.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*passive*] 
#   Passive queue creation? Useful for checking queue existance without
#   modifying server state
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*password*] 
#   Your amqp password
#   Value type is password
#   Default value: "guest"
#   This variable is optional
#
# [*port*] 
#   The AMQP port to connect on
#   Value type is number
#   Default value: 5672
#   This variable is optional
#
# [*prefetch_count*] 
#   Prefetch count. Number of messages to prefetch
#   Value type is number
#   Default value: 1
#   This variable is optional
#
# [*ssl*] 
#   Enable or disable SSL
#   Value type is boolean
#   Default value: false
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
# [*user*] 
#   Your amqp username
#   Value type is string
#   Default value: "guest"
#   This variable is optional
#
# [*verify_ssl*] 
#   Validate SSL certificate
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*vhost*] 
#   The vhost to use. If you don't know what this is, leave the default.
#   Value type is string
#   Default value: "/"
#   This variable is optional
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
#  http://logstash.net/docs/1.1.5/inputs/amqp
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::amqp(
  $exchange,
  $type,
  $host,
  $name           = '',
  $debug          = '',
  $durable        = '',
  $ack            = '',
  $exclusive      = '',
  $format         = '',
  $arguments      = '',
  $key            = '',
  $message_format = '',
  $auto_delete    = '',
  $passive        = '',
  $password       = '',
  $port           = '',
  $prefetch_count = '',
  $ssl            = '',
  $tags           = '',
  $threads        = '',
  $add_field      = '',
  $user           = '',
  $verify_ssl     = '',
  $vhost          = '',
) {

  require logstash::params

  #### Validate parameters
  if $arguments {
    validate_array($arguments)
    $arr_arguments = join($arguments, "', '")
    $opt_arguments = "  arguments => ['${arr_arguments}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $auto_delete {
    validate_bool($auto_delete)
    $opt_auto_delete = "  auto_delete => ${auto_delete}\n"
  }

  if $ack {
    validate_bool($ack)
    $opt_ack = "  ack => ${ack}\n"
  }

  if $durable {
    validate_bool($durable)
    $opt_durable = "  durable => ${durable}\n"
  }

  if $ssl {
    validate_bool($ssl)
    $opt_ssl = "  ssl => ${ssl}\n"
  }

  if $exclusive {
    validate_bool($exclusive)
    $opt_exclusive = "  exclusive => ${exclusive}\n"
  }

  if $passive {
    validate_bool($passive)
    $opt_passive = "  passive => ${passive}\n"
  }

  if $verify_ssl {
    validate_bool($verify_ssl)
    $opt_verify_ssl = "  verify_ssl => ${verify_ssl}\n"
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

  if $prefetch_count {
    if ! is_numeric($prefetch_count) {
      fail("\"${prefetch_count}\" is not a valid prefetch_count parameter value")
    }
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    }
  }

  if $format {
    if ! ($format in ['plain', 'json', 'json_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if $password { 
    validate_string($password)
    $opt_password = "  password => \"${password}\"\n"
  }

  if $name { 
    validate_string($name)
    $opt_name = "  name => \"${name}\"\n"
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

  if $user { 
    validate_string($user)
    $opt_user = "  user => \"${user}\"\n"
  }

  if $exchange { 
    validate_string($exchange)
    $opt_exchange = "  exchange => \"${exchange}\"\n"
  }

  if $vhost { 
    validate_string($vhost)
    $opt_vhost = "  vhost => \"${vhost}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/input_amqp_${name}":
    ensure  => present,
    content => "input {\n amqp {\n${opt_ack}${opt_add_field}${opt_arguments}${opt_auto_delete}${opt_debug}${opt_durable}${opt_exchange}${opt_exclusive}${opt_format}${opt_host}${opt_key}${opt_message_format}${opt_name}${opt_passive}${opt_password}${opt_port}${opt_prefetch_count}${opt_ssl}${opt_tags}${opt_threads}${opt_type}${opt_user}${opt_verify_ssl}${opt_vhost} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

# == Define: logstash::output::amqp
#
#   Push events to an AMQP exchange.   NOTE: THIS IS ONLY KNOWN TO WORK
#   WITH RECENT RELEASES OF RABBITMQ. Any other amqp broker will not work
#   with this plugin. I do not know why. If you need support for brokers
#   other than rabbitmq, please file bugs here:
#   https://github.com/ruby-amqp/bunny   AMQP is a messaging system. It
#   requires you to run an AMQP server or 'broker' Examples of AMQP
#   servers are RabbitMQ and QPid
#
#
# === Parameters
#
# [*debug*] 
#   Enable or disable debugging
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*durable*] 
#   Is this exchange durable? (aka; Should it survive a broker restart?)
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*exchange_type*] 
#   The exchange type (fanout, topic, direct)
#   Value can be any of: "fanout", "direct", "topic"
#   Default value: None
#   This variable is required
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
# [*host*] 
#   Your amqp server address
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*key*] 
#   Key to route to by default. Defaults to 'logstash'  Routing keys are
#   ignored on fanout exchanges.
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*name*] 
#   The name of the exchange
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*password*] 
#   Your amqp password
#   Value type is password
#   Default value: "guest"
#   This variable is optional
#
# [*persistent*] 
#   Should messages persist to disk on the AMQP broker until they are read
#   by a consumer?
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*port*] 
#   The AMQP port to connect on
#   Value type is number
#   Default value: 5672
#   This variable is optional
#
# [*ssl*] 
#   Enable or disable SSL
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
# [*type*] 
#   The type to act on. If a type is given, then this output will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
#   This variable is optional
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
#   The vhost to use
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
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.5/outputs/amqp
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::amqp(
  $exchange_type,
  $name,
  $host,
  $password      = '',
  $fields        = '',
  $debug         = '',
  $key           = '',
  $durable       = '',
  $exclude_tags  = '',
  $persistent    = '',
  $port          = '',
  $ssl           = '',
  $tags          = '',
  $type          = '',
  $user          = '',
  $verify_ssl    = '',
  $vhost         = '',
) {

  require logstash::params

  #### Validate parameters
  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, "', '")
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, "', '")
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $persistent {
    validate_bool($persistent)
    $opt_persistent = "  persistent => ${persistent}\n"
  }

  if $durable {
    validate_bool($durable)
    $opt_durable = "  durable => ${durable}\n"
  }

  if $ssl {
    validate_bool($ssl)
    $opt_ssl = "  ssl => ${ssl}\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $verify_ssl {
    validate_bool($verify_ssl)
    $opt_verify_ssl = "  verify_ssl => ${verify_ssl}\n"
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    }
  }

  if $exchange_type {
    if ! ($exchange_type in ['fanout', 'direct', 'topic']) {
      fail("\"${exchange_type}\" is not a valid exchange_type parameter value")
    } else {
      $opt_exchange_type = "  exchange_type => \"${exchange_type}\"\n"
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

  if $key { 
    validate_string($key)
    $opt_key = "  key => \"${key}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $user { 
    validate_string($user)
    $opt_user = "  user => \"${user}\"\n"
  }

  if $host { 
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $vhost { 
    validate_string($vhost)
    $opt_vhost = "  vhost => \"${vhost}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_amqp_${name}":
    ensure  => present,
    content => "output {\n amqp {\n${opt_debug}${opt_durable}${opt_exchange_type}${opt_exclude_tags}${opt_fields}${opt_host}${opt_key}${opt_name}${opt_password}${opt_persistent}${opt_port}${opt_ssl}${opt_tags}${opt_type}${opt_user}${opt_verify_ssl}${opt_vhost} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

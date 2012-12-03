# == Define: logstash::input::zeromq
#
#   Read events over a 0MQ SUB socket.  You need to have the 0mq 2.1.x
#   library installed to be able to use this input plugin.  The default
#   settings will create a subscriber binding to tcp://127.0.0.1:2120
#   waiting for connecting publishers.
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
# [*address*] 
#   0mq socket address to connect or bind Please note that inproc:// will
#   not work with logstash as each we use a context per thread. By
#   default, inputs bind/listen and outputs connect
#   Value type is array
#   Default value: ["tcp://*:2120"]
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
# [*mode*] 
#   mode server mode binds/listens client mode connects
#   Value can be any of: "server", "client"
#   Default value: "server"
#   This variable is optional
#
# [*sender*] 
#   sender overrides the sender to set the source of the event default is
#   "zmq+topology://type/"
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*sockopt*] 
#   0mq socket options This exposes zmq_setsockopt for advanced tuning see
#   http://api.zeromq.org/2-1:zmq-setsockopt for details  This is where
#   you would set values like: ZMQ::HWM - high water mark ZMQ::IDENTITY -
#   named queues ZMQ::SWAP_SIZE - space for disk overflow  example:
#   sockopt =&gt; ["ZMQ::HWM", 50, "ZMQ::IDENTITY", "mynamedqueue"]
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*tags*] 
#   Add any number of arbitrary tags to your event.  This can help with
#   processing later.
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*topic*] 
#   0mq topic This is used for the 'pubsub' topology only On inputs, this
#   allows you to filter messages by topic On outputs, this allows you to
#   tag a message for routing NOTE: ZeroMQ does subscriber side filtering.
#   NOTE: All topics have an implicit wildcard at the end You can specify
#   multiple topics here
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*topology*] 
#   0mq topology The default logstash topologies work as follows: *
#   pushpull - inputs are pull, outputs are push * pubsub - inputs are
#   subscribers, outputs are publishers * pair - inputs are clients,
#   inputs are servers  If the predefined topology flows don't work for
#   you, you can change the 'mode' setting TODO (lusis) add req/rep MAYBE
#   TODO (lusis) add router/dealer
#   Value can be any of: "pushpull", "pubsub", "pair"
#   Default value: None
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
#  http://logstash.net/docs/1.1.5/inputs/zeromq
#
#  Need help? http://logstash.net/docs/1.1.5/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::zeromq(
  $type,
  $sender         = '',
  $debug          = '',
  $format         = '',
  $message_format = '',
  $mode           = '',
  $address        = '',
  $sockopt        = '',
  $tags           = '',
  $topic          = '',
  $topology       = '',
  $add_field      = '',
) {

  require logstash::params

  #### Validate parameters
  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, "', '")
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $address {
    validate_array($address)
    $arr_address = join($address, "', '")
    $opt_address = "  address => ['${arr_address}']\n"
  }

  if $topic {
    validate_array($topic)
    $arr_topic = join($topic, "', '")
    $opt_topic = "  topic => ['${arr_topic}']\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $sockopt {
    validate_hash($sockopt)
    $arr_sockopt = inline_template('<%= sockopt.to_a.flatten.inspect %>')
    $opt_sockopt = "  sockopt => ${arr_sockopt}\n"
  }

  if $add_field {
    validate_hash($add_field)
    $arr_add_field = inline_template('<%= add_field.to_a.flatten.inspect %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if $mode {
    if ! ($mode in ['server', 'client']) {
      fail("\"${mode}\" is not a valid mode parameter value")
    } else {
      $opt_mode = "  mode => \"${mode}\"\n"
    }
  }

  if $format {
    if ! ($format in ['plain', 'json', 'json_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if $topology {
    if ! ($topology in ['pushpull', 'pubsub', 'pair']) {
      fail("\"${topology}\" is not a valid topology parameter value")
    } else {
      $opt_topology = "  topology => \"${topology}\"\n"
    }
  }

  if $sender { 
    validate_string($sender)
    $opt_sender = "  sender => \"${sender}\"\n"
  }

  if $message_format { 
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $type { 
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/input_zeromq_${name}":
    ensure  => present,
    content => "input {\n zeromq {\n${opt_add_field}${opt_address}${opt_debug}${opt_format}${opt_message_format}${opt_mode}${opt_sender}${opt_sockopt}${opt_tags}${opt_topic}${opt_topology}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

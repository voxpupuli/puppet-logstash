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
# [*charset*]
#   The character encoding used in this input. Examples include "UTF-8"
#   and "cp1252"  This setting is useful if your log files are in Latin-1
#   (aka cp1252) or in another character set other than UTF-8.  This only
#   affects "plain" format logs since json is UTF-8 already.
#   Value can be any of: "ASCII-8BIT", "UTF-8", "US-ASCII", "Big5",
#   "Big5-HKSCS", "Big5-UAO", "CP949", "Emacs-Mule", "EUC-JP", "EUC-KR",
#   "EUC-TW", "GB18030", "GBK", "ISO-8859-1", "ISO-8859-2", "ISO-8859-3",
#   "ISO-8859-4", "ISO-8859-5", "ISO-8859-6", "ISO-8859-7", "ISO-8859-8",
#   "ISO-8859-9", "ISO-8859-10", "ISO-8859-11", "ISO-8859-13",
#   "ISO-8859-14", "ISO-8859-15", "ISO-8859-16", "KOI8-R", "KOI8-U",
#   "Shift_JIS", "UTF-16BE", "UTF-16LE", "UTF-32BE", "UTF-32LE",
#   "Windows-1251", "BINARY", "IBM437", "CP437", "IBM737", "CP737",
#   "IBM775", "CP775", "CP850", "IBM850", "IBM852", "CP852", "IBM855",
#   "CP855", "IBM857", "CP857", "IBM860", "CP860", "IBM861", "CP861",
#   "IBM862", "CP862", "IBM863", "CP863", "IBM864", "CP864", "IBM865",
#   "CP865", "IBM866", "CP866", "IBM869", "CP869", "Windows-1258",
#   "CP1258", "GB1988", "macCentEuro", "macCroatian", "macCyrillic",
#   "macGreek", "macIceland", "macRoman", "macRomania", "macThai",
#   "macTurkish", "macUkraine", "CP950", "Big5-HKSCS:2008", "CP951",
#   "stateless-ISO-2022-JP", "eucJP", "eucJP-ms", "euc-jp-ms", "CP51932",
#   "eucKR", "eucTW", "GB2312", "EUC-CN", "eucCN", "GB12345", "CP936",
#   "ISO-2022-JP", "ISO2022-JP", "ISO-2022-JP-2", "ISO2022-JP2",
#   "CP50220", "CP50221", "ISO8859-1", "Windows-1252", "CP1252",
#   "ISO8859-2", "Windows-1250", "CP1250", "ISO8859-3", "ISO8859-4",
#   "ISO8859-5", "ISO8859-6", "Windows-1256", "CP1256", "ISO8859-7",
#   "Windows-1253", "CP1253", "ISO8859-8", "Windows-1255", "CP1255",
#   "ISO8859-9", "Windows-1254", "CP1254", "ISO8859-10", "ISO8859-11",
#   "TIS-620", "Windows-874", "CP874", "ISO8859-13", "Windows-1257",
#   "CP1257", "ISO8859-14", "ISO8859-15", "ISO8859-16", "CP878",
#   "Windows-31J", "CP932", "csWindows31J", "SJIS", "PCK", "MacJapanese",
#   "MacJapan", "ASCII", "ANSI_X3.4-1968", "646", "UTF-7", "CP65000",
#   "CP65001", "UTF8-MAC", "UTF-8-MAC", "UTF-8-HFS", "UTF-16", "UTF-32",
#   "UCS-2BE", "UCS-4BE", "UCS-4LE", "CP1251", "UTF8-DoCoMo",
#   "SJIS-DoCoMo", "UTF8-KDDI", "SJIS-KDDI", "ISO-2022-JP-KDDI",
#   "stateless-ISO-2022-JP-KDDI", "UTF8-SoftBank", "SJIS-SoftBank",
#   "locale", "external", "filesystem", "internal"
#   Default value: "UTF-8"
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
#   Value can be any of: "plain", "json", "json_event", "msgpack_event"
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
#   This variable is required
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
#   This variable is required
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
#  Extra information about this input can be found at:
#  http://logstash.net/docs/1.1.12/inputs/zeromq
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::zeromq (
  $topology,
  $type,
  $sender         = '',
  $debug          = '',
  $format         = '',
  $message_format = '',
  $mode           = '',
  $charset        = '',
  $sockopt        = '',
  $tags           = '',
  $topic          = '',
  $add_field      = '',
  $address        = '',
  $instances      = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_zeromq_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/zeromq/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_zeromq_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/zeromq/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($address != '') {
    validate_array($address)
    $arr_address = join($address, '\', \'')
    $opt_address = "  address => ['${arr_address}']\n"
  }

  if ($topic != '') {
    validate_array($topic)
    $arr_topic = join($topic, '\', \'')
    $opt_topic = "  topic => ['${arr_topic}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if ($sockopt != '') {
    validate_hash($sockopt)
    $var_sockopt = $sockopt
    $arr_sockopt = inline_template('<%= "["+var_sockopt.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_sockopt = "  sockopt => ${arr_sockopt}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if ($mode != '') {
    if ! ($mode in ['server', 'client']) {
      fail("\"${mode}\" is not a valid mode parameter value")
    } else {
      $opt_mode = "  mode => \"${mode}\"\n"
    }
  }

  if ($topology != '') {
    if ! ($topology in ['pushpull', 'pubsub', 'pair']) {
      fail("\"${topology}\" is not a valid topology parameter value")
    } else {
      $opt_topology = "  topology => \"${topology}\"\n"
    }
  }

  if ($format != '') {
    if ! ($format in ['plain', 'json', 'json_event', 'msgpack_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if ($charset != '') {
    if ! ($charset in ['ASCII-8BIT', 'UTF-8', 'US-ASCII', 'Big5', 'Big5-HKSCS', 'Big5-UAO', 'CP949', 'Emacs-Mule', 'EUC-JP', 'EUC-KR', 'EUC-TW', 'GB18030', 'GBK', 'ISO-8859-1', 'ISO-8859-2', 'ISO-8859-3', 'ISO-8859-4', 'ISO-8859-5', 'ISO-8859-6', 'ISO-8859-7', 'ISO-8859-8', 'ISO-8859-9', 'ISO-8859-10', 'ISO-8859-11', 'ISO-8859-13', 'ISO-8859-14', 'ISO-8859-15', 'ISO-8859-16', 'KOI8-R', 'KOI8-U', 'Shift_JIS', 'UTF-16BE', 'UTF-16LE', 'UTF-32BE', 'UTF-32LE', 'Windows-1251', 'BINARY', 'IBM437', 'CP437', 'IBM737', 'CP737', 'IBM775', 'CP775', 'CP850', 'IBM850', 'IBM852', 'CP852', 'IBM855', 'CP855', 'IBM857', 'CP857', 'IBM860', 'CP860', 'IBM861', 'CP861', 'IBM862', 'CP862', 'IBM863', 'CP863', 'IBM864', 'CP864', 'IBM865', 'CP865', 'IBM866', 'CP866', 'IBM869', 'CP869', 'Windows-1258', 'CP1258', 'GB1988', 'macCentEuro', 'macCroatian', 'macCyrillic', 'macGreek', 'macIceland', 'macRoman', 'macRomania', 'macThai', 'macTurkish', 'macUkraine', 'CP950', 'Big5-HKSCS:2008', 'CP951', 'stateless-ISO-2022-JP', 'eucJP', 'eucJP-ms', 'euc-jp-ms', 'CP51932', 'eucKR', 'eucTW', 'GB2312', 'EUC-CN', 'eucCN', 'GB12345', 'CP936', 'ISO-2022-JP', 'ISO2022-JP', 'ISO-2022-JP-2', 'ISO2022-JP2', 'CP50220', 'CP50221', 'ISO8859-1', 'Windows-1252', 'CP1252', 'ISO8859-2', 'Windows-1250', 'CP1250', 'ISO8859-3', 'ISO8859-4', 'ISO8859-5', 'ISO8859-6', 'Windows-1256', 'CP1256', 'ISO8859-7', 'Windows-1253', 'CP1253', 'ISO8859-8', 'Windows-1255', 'CP1255', 'ISO8859-9', 'Windows-1254', 'CP1254', 'ISO8859-10', 'ISO8859-11', 'TIS-620', 'Windows-874', 'CP874', 'ISO8859-13', 'Windows-1257', 'CP1257', 'ISO8859-14', 'ISO8859-15', 'ISO8859-16', 'CP878', 'Windows-31J', 'CP932', 'csWindows31J', 'SJIS', 'PCK', 'MacJapanese', 'MacJapan', 'ASCII', 'ANSI_X3.4-1968', '646', 'UTF-7', 'CP65000', 'CP65001', 'UTF8-MAC', 'UTF-8-MAC', 'UTF-8-HFS', 'UTF-16', 'UTF-32', 'UCS-2BE', 'UCS-4BE', 'UCS-4LE', 'CP1251', 'UTF8-DoCoMo', 'SJIS-DoCoMo', 'UTF8-KDDI', 'SJIS-KDDI', 'ISO-2022-JP-KDDI', 'stateless-ISO-2022-JP-KDDI', 'UTF8-SoftBank', 'SJIS-SoftBank', 'locale', 'external', 'filesystem', 'internal']) {
      fail("\"${charset}\" is not a valid charset parameter value")
    } else {
      $opt_charset = "  charset => \"${charset}\"\n"
    }
  }

  if ($message_format != '') {
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($sender != '') {
    validate_string($sender)
    $opt_sender = "  sender => \"${sender}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n zeromq {\n${opt_add_field}${opt_address}${opt_charset}${opt_debug}${opt_format}${opt_message_format}${opt_mode}${opt_sender}${opt_sockopt}${opt_tags}${opt_topic}${opt_topology}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

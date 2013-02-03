# == Define: logstash::output::elasticsearch_river
#
#   This output lets you store logs in elasticsearch. It's similar to the
#   'elasticsearch' output but improves performance by using an AMQP
#   server, such as rabbitmq, to send data to elasticsearch.  Upon
#   startup, this output will automatically contact an elasticsearch
#   cluster and configure it to read from the queue to which we write.
#   You can learn more about elasticseasrch at http://elasticsearch.org
#   More about the elasticsearch rabbitmq river plugin:
#   https://github.com/elasticsearch/elasticsearch-river-rabbitmq/blob/master/README.md
#
#
# === Parameters
#
# [*amqp_host*]
#   Hostname of AMQP server
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*amqp_port*]
#   Port of AMQP server
#   Value type is number
#   Default value: 5672
#   This variable is optional
#
# [*debug*]
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*document_id*]
#   The document ID for the index. Useful for overwriting existing entries
#   in elasticsearch with the same ID.
#   Value type is string
#   Default value: nil
#   This variable is optional
#
# [*durable*]
#   AMQP durability setting. Also used for ElasticSearch setting
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*es_bulk_size*]
#   ElasticSearch river configuration: bulk fetch size
#   Value type is number
#   Default value: 1000
#   This variable is optional
#
# [*es_bulk_timeout_ms*]
#   ElasticSearch river configuration: bulk timeout in milliseconds
#   Value type is number
#   Default value: 100
#   This variable is optional
#
# [*es_host*]
#   The name/address of an ElasticSearch host to use for river creation
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*es_port*]
#   ElasticSearch API port
#   Value type is number
#   Default value: 9200
#   This variable is optional
#
# [*exchange*]
#   AMQP exchange name
#   Value type is string
#   Default value: "elasticsearch"
#   This variable is optional
#
# [*exchange_type*]
#   The exchange type (fanout, topic, direct)
#   Value can be any of: "fanout", "direct", "topic"
#   Default value: "direct"
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
# [*index*]
#   The index to write events to. This can be dynamic using the %{foo}
#   syntax. The default value will partition your indeces by day so you
#   can more easily delete old data or only search specific date ranges.
#   Value type is string
#   Default value: "logstash-%{+YYYY.MM.dd}"
#   This variable is optional
#
# [*index_type*]
#   The index type to write events to. Generally you should try to write
#   only similar events to the same 'type'. String expansion '%{foo}'
#   works here.
#   Value type is string
#   Default value: "%{@type}"
#   This variable is optional
#
# [*key*]
#   AMQP routing key
#   Value type is string
#   Default value: "elasticsearch"
#   This variable is optional
#
# [*password*]
#   AMQP password
#   Value type is string
#   Default value: "guest"
#   This variable is optional
#
# [*persistent*]
#   AMQP persistence setting
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*queue*]
#   AMQP queue name
#   Value type is string
#   Default value: "elasticsearch"
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
#   AMQP user
#   Value type is string
#   Default value: "guest"
#   This variable is optional
#
# [*vhost*]
#   AMQP vhost
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
#  This define is created based on LogStash version 1.1.9
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.9/outputs/elasticsearch_river
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::elasticsearch_river (
  $amqp_host,
  $es_host,
  $fields             = '',
  $document_id        = '',
  $durable            = '',
  $es_bulk_size       = '',
  $es_bulk_timeout_ms = '',
  $amqp_port          = '',
  $es_port            = '',
  $exchange           = '',
  $exchange_type      = '',
  $exclude_tags       = '',
  $debug              = '',
  $index              = '',
  $index_type         = '',
  $key                = '',
  $password           = '',
  $persistent         = '',
  $queue              = '',
  $tags               = '',
  $type               = '',
  $user               = '',
  $vhost              = ''
) {


  require logstash::params

  #### Validate parameters
  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $persistent {
    validate_bool($persistent)
    $opt_persistent = "  persistent => ${persistent}\n"
  }

  if $debug {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if $durable {
    validate_bool($durable)
    $opt_durable = "  durable => ${durable}\n"
  }

  if $es_bulk_timeout_ms {
    if ! is_numeric($es_bulk_timeout_ms) {
      fail("\"${es_bulk_timeout_ms}\" is not a valid es_bulk_timeout_ms parameter value")
    } else {
      $opt_es_bulk_timeout_ms = "  es_bulk_timeout_ms => ${es_bulk_timeout_ms}\n"
    }
  }

  if $amqp_port {
    if ! is_numeric($amqp_port) {
      fail("\"${amqp_port}\" is not a valid amqp_port parameter value")
    } else {
      $opt_amqp_port = "  amqp_port => ${amqp_port}\n"
    }
  }

  if $es_port {
    if ! is_numeric($es_port) {
      fail("\"${es_port}\" is not a valid es_port parameter value")
    } else {
      $opt_es_port = "  es_port => ${es_port}\n"
    }
  }

  if $es_bulk_size {
    if ! is_numeric($es_bulk_size) {
      fail("\"${es_bulk_size}\" is not a valid es_bulk_size parameter value")
    } else {
      $opt_es_bulk_size = "  es_bulk_size => ${es_bulk_size}\n"
    }
  }

  if $exchange_type {
    if ! ($exchange_type in ['fanout', 'direct', 'topic']) {
      fail("\"${exchange_type}\" is not a valid exchange_type parameter value")
    } else {
      $opt_exchange_type = "  exchange_type => \"${exchange_type}\"\n"
    }
  }

  if $amqp_host {
    validate_string($amqp_host)
    $opt_amqp_host = "  amqp_host => \"${amqp_host}\"\n"
  }

  if $exchange {
    validate_string($exchange)
    $opt_exchange = "  exchange => \"${exchange}\"\n"
  }

  if $index {
    validate_string($index)
    $opt_index = "  index => \"${index}\"\n"
  }

  if $index_type {
    validate_string($index_type)
    $opt_index_type = "  index_type => \"${index_type}\"\n"
  }

  if $key {
    validate_string($key)
    $opt_key = "  key => \"${key}\"\n"
  }

  if $password {
    validate_string($password)
    $opt_password = "  password => \"${password}\"\n"
  }

  if $es_host {
    validate_string($es_host)
    $opt_es_host = "  es_host => \"${es_host}\"\n"
  }

  if $queue {
    validate_string($queue)
    $opt_queue = "  queue => \"${queue}\"\n"
  }

  if $document_id {
    validate_string($document_id)
    $opt_document_id = "  document_id => \"${document_id}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $user {
    validate_string($user)
    $opt_user = "  user => \"${user}\"\n"
  }

  if $vhost {
    validate_string($vhost)
    $opt_vhost = "  vhost => \"${vhost}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_elasticsearch_river_${name}":
    ensure  => present,
    content => "output {\n elasticsearch_river {\n${opt_amqp_host}${opt_amqp_port}${opt_debug}${opt_document_id}${opt_durable}${opt_es_bulk_size}${opt_es_bulk_timeout_ms}${opt_es_host}${opt_es_port}${opt_exchange}${opt_exchange_type}${opt_exclude_tags}${opt_fields}${opt_index}${opt_index_type}${opt_key}${opt_password}${opt_persistent}${opt_queue}${opt_tags}${opt_type}${opt_user}${opt_vhost} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

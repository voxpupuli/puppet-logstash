# == Define: logstash::output::redis
#
#   send events to a redis database using RPUSH  For more information
#   about redis, see http://redis.io/
#
#
# === Parameters
#
# [*batch*]
#   Set to true if you want redis to batch up values and send 1 RPUSH
#   command instead of one command per value to push on the list.  Note
#   that this only works with data_type="list" mode right now.  If true,
#   we send an RPUSH every "batchevents" events or "batchtimeout" seconds
#   (whichever comes first).
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*batch_events*]
#   If batch is set to true, the number of events we queue up for an
#   RPUSH.
#   Value type is number
#   Default value: 50
#   This variable is optional
#
# [*batch_timeout*]
#   If batch is set to true, the maximum amount of time between RPUSH
#   commands when there are pending events to flush.
#   Value type is number
#   Default value: 5
#   This variable is optional
#
# [*data_type*]
#   Either list or channel.  If redistype is list, then we will RPUSH to
#   key. If redistype is channel, then we will PUBLISH to key. TODO set
#   required true
#   Value can be any of: "list", "channel"
#   Default value: None
#   This variable is optional
#
# [*db*]
#   The redis database number.
#   Value type is number
#   Default value: 0
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
# [*host*]
#   The hostname(s) of your redis server(s). Ports may be specified on any
#   hostname, which will override the global port config.  For example:
#   "127.0.0.1" ["127.0.0.1", "127.0.0.2"] ["127.0.0.1:6380", "127.0.0.1"]
#   Value type is array
#   Default value: ["127.0.0.1"]
#   This variable is optional
#
# [*key*]
#   The name of a redis list or channel. Dynamic names are valid here, for
#   example "logstash-%{@type}". TODO set required true
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*password*]
#   Password to authenticate with.  There is no authentication by default.
#   Value type is password
#   Default value: None
#   This variable is optional
#
# [*port*]
#   The default port to connect on. Can be overridden on any hostname.
#   Value type is number
#   Default value: 6379
#   This variable is optional
#
# [*shuffle_hosts*]
#   Shuffle the host list during logstash startup.
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*timeout*]
#   Redis initial connection timeout in seconds.
#   Value type is number
#   Default value: 5
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
#  http://logstash.net/docs/1.1.9/outputs/redis
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::redis (
  $batch         = '',
  $batch_events  = '',
  $batch_timeout = '',
  $data_type     = '',
  $db            = '',
  $exclude_tags  = '',
  $fields        = '',
  $host          = '',
  $key           = '',
  $password      = '',
  $port          = '',
  $shuffle_hosts = '',
  $tags          = '',
  $timeout       = '',
  $type          = ''
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

  if $host {
    validate_array($host)
    $arr_host = join($host, '\', \'')
    $opt_host = "  host => ['${arr_host}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $batch {
    validate_bool($batch)
    $opt_batch = "  batch => ${batch}\n"
  }

  if $shuffle_hosts {
    validate_bool($shuffle_hosts)
    $opt_shuffle_hosts = "  shuffle_hosts => ${shuffle_hosts}\n"
  }

  if $db {
    if ! is_numeric($db) {
      fail("\"${db}\" is not a valid db parameter value")
    } else {
      $opt_db = "  db => ${db}\n"
    }
  }

  if $batch_timeout {
    if ! is_numeric($batch_timeout) {
      fail("\"${batch_timeout}\" is not a valid batch_timeout parameter value")
    } else {
      $opt_batch_timeout = "  batch_timeout => ${batch_timeout}\n"
    }
  }

  if $timeout {
    if ! is_numeric($timeout) {
      fail("\"${timeout}\" is not a valid timeout parameter value")
    } else {
      $opt_timeout = "  timeout => ${timeout}\n"
    }
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if $batch_events {
    if ! is_numeric($batch_events) {
      fail("\"${batch_events}\" is not a valid batch_events parameter value")
    } else {
      $opt_batch_events = "  batch_events => ${batch_events}\n"
    }
  }

  if $data_type {
    if ! ($data_type in ['list', 'channel']) {
      fail("\"${data_type}\" is not a valid data_type parameter value")
    } else {
      $opt_data_type = "  data_type => \"${data_type}\"\n"
    }
  }

  if $password {
    validate_string($password)
    $opt_password = "  password => \"${password}\"\n"
  }

  if $key {
    validate_string($key)
    $opt_key = "  key => \"${key}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_redis_${name}":
    ensure  => present,
    content => "output {\n redis {\n${opt_batch}${opt_batch_events}${opt_batch_timeout}${opt_data_type}${opt_db}${opt_exclude_tags}${opt_fields}${opt_host}${opt_key}${opt_password}${opt_port}${opt_shuffle_hosts}${opt_tags}${opt_timeout}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

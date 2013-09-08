# == Define: logstash::output::elasticsearch_http
#
#   This output lets you store logs in elasticsearch.  This plugin uses
#   the HTTP/REST interface to ElasticSearch, which usually lets you use
#   any version of elasticsearch server. It is known to work with
#   elasticsearch %ELASTICSEARCH_VERSION%  You can learn more about
#   elasticsearch at http://elasticsearch.org
#
#
# === Parameters
#
# [*document_id*]
#   The document ID for the index. Useful for overwriting existing entries
#   in elasticsearch with the same ID.
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
# [*flush_size*]
#   Set the number of events to queue up before writing to elasticsearch.
#   If this value is set to 1, the normal 'index api'. Otherwise, the bulk
#   api will be used.
#   Value type is number
#   Default value: 100
#   This variable is optional
#
# [*host*]
#   The hostname or ip address to reach your elasticsearch server.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*index*]
#   The index to write events to. This can be dynamic using the %{foo}
#   syntax. The default value will partition your indices by day so you
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
# [*port*]
#   The port for ElasticSearch HTTP interface to use.
#   Value type is number
#   Default value: 9200
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
#  http://logstash.net/docs/1.1.12/outputs/elasticsearch_http
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::elasticsearch_http (
  $document_id  = '',
  $exclude_tags = '',
  $fields       = '',
  $flush_size   = '',
  $host         = '',
  $index        = '',
  $index_type   = '',
  $port         = '',
  $tags         = '',
  $type         = '',
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_elasticsearch_http_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/elasticsearch_http/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_elasticsearch_http_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/elasticsearch_http/${name}"

  }

  #### Validate parameters

  validate_array($instances)

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

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($flush_size != '') {
    if ! is_numeric($flush_size) {
      fail("\"${flush_size}\" is not a valid flush_size parameter value")
    } else {
      $opt_flush_size = "  flush_size => ${flush_size}\n"
    }
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if ($index != '') {
    validate_string($index)
    $opt_index = "  index => \"${index}\"\n"
  }

  if ($index_type != '') {
    validate_string($index_type)
    $opt_index_type = "  index_type => \"${index_type}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($document_id != '') {
    validate_string($document_id)
    $opt_document_id = "  document_id => \"${document_id}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n elasticsearch_http {\n${opt_document_id}${opt_exclude_tags}${opt_fields}${opt_flush_size}${opt_host}${opt_index}${opt_index_type}${opt_port}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

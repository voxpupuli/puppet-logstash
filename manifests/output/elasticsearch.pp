# == Define: logstash::output::elasticsearch
#
#   This output lets you store logs in elasticsearch and is the most
#   recommended output for logstash. If you plan on using the logstash web
#   interface, you'll need to use this output.    VERSION NOTE: Your
#   elasticsearch cluster must be running elasticsearch
#   %ELASTICSEARCH_VERSION%. If you use any other version of
#   elasticsearch,   you should consider using the elasticsearch_http
#   output instead.  If you want to set other elasticsearch options that
#   are not exposed directly as config options, there are two options:
#   create an elasticsearch.yml file in the $PWD of the logstash process
#   pass in es.* java properties (java -Des.node.foo= or ruby
#   -J-Des.node.foo=) This plugin will join your elasticsearch cluster, so
#   it will show up in elasticsearch's cluster health status.  You can
#   learn more about elasticsearch at http://elasticsearch.org
#   Operational Notes  Your firewalls will need to permit port 9300 in
#   both directions (from logstash to elasticsearch, and elasticsearch to
#   logstash)
#
#
# === Parameters
#
# [*bind_host*]
#   The name/address of the host to bind to for ElasticSearch clustering
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*cluster*]
#   The name of your cluster if you set it on the ElasticSearch side.
#   Useful for discovery.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*document_id*]
#   The document ID for the index. Useful for overwriting existing entries
#   in elasticsearch with the same ID.
#   Value type is string
#   Default value: nil
#   This variable is optional
#
# [*embedded*]
#   Run the elasticsearch server embedded in this process. This option is
#   useful if you want to run a single logstash process that handles log
#   processing and indexing; it saves you from needing to run a separate
#   elasticsearch process.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*embedded_http_port*]
#   If you are running the embedded elasticsearch server, you can set the
#   http port it listens on here; it is not common to need this setting
#   changed from default.
#   Value type is string
#   Default value: "9200-9300"
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
#   The name/address of the host to use for ElasticSearch unicast
#   discovery This is only required if the normal multicast/cluster
#   discovery stuff won't work in your environment.
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
# [*max_inflight_requests*]
#   Configure the maximum number of in-flight requests to ElasticSearch.
#   Note: This setting may be removed in the future.
#   Value type is number
#   Default value: 50
#   This variable is optional
#
# [*node_name*]
#   The node name ES will use when joining a cluster.  By default, this is
#   generated internally by the ES client.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*port*]
#   The port for ElasticSearch transport to use. This is not the
#   ElasticSearch REST API port (normally 9200).
#   Value type is number
#   Default value: "9300-9400"
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
#  http://logstash.net/docs/1.1.12/outputs/elasticsearch
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::elasticsearch (
  $bind_host             = '',
  $cluster               = '',
  $document_id           = '',
  $embedded              = '',
  $embedded_http_port    = '',
  $exclude_tags          = '',
  $fields                = '',
  $host                  = '',
  $index                 = '',
  $index_type            = '',
  $max_inflight_requests = '',
  $node_name             = '',
  $port                  = '',
  $tags                  = '',
  $type                  = '',
  $instances             = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_elasticsearch_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/elasticsearch/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_elasticsearch_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/elasticsearch/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

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

  if ($embedded != '') {
    validate_bool($embedded)
    $opt_embedded = "  embedded => ${embedded}\n"
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if ($max_inflight_requests != '') {
    if ! is_numeric($max_inflight_requests) {
      fail("\"${max_inflight_requests}\" is not a valid max_inflight_requests parameter value")
    } else {
      $opt_max_inflight_requests = "  max_inflight_requests => ${max_inflight_requests}\n"
    }
  }

  if ($index != '') {
    validate_string($index)
    $opt_index = "  index => \"${index}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if ($index_type != '') {
    validate_string($index_type)
    $opt_index_type = "  index_type => \"${index_type}\"\n"
  }

  if ($embedded_http_port != '') {
    validate_string($embedded_http_port)
    $opt_embedded_http_port = "  embedded_http_port => \"${embedded_http_port}\"\n"
  }

  if ($node_name != '') {
    validate_string($node_name)
    $opt_node_name = "  node_name => \"${node_name}\"\n"
  }

  if ($document_id != '') {
    validate_string($document_id)
    $opt_document_id = "  document_id => \"${document_id}\"\n"
  }

  if ($cluster != '') {
    validate_string($cluster)
    $opt_cluster = "  cluster => \"${cluster}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($bind_host != '') {
    validate_string($bind_host)
    $opt_bind_host = "  bind_host => \"${bind_host}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n elasticsearch {\n${opt_bind_host}${opt_cluster}${opt_document_id}${opt_embedded}${opt_embedded_http_port}${opt_exclude_tags}${opt_fields}${opt_host}${opt_index}${opt_index_type}${opt_max_inflight_requests}${opt_node_name}${opt_port}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

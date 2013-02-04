# == Define: logstash::output::riak
#
#   Riak is a distributed k/v store from Basho. It's based on the Dynamo
#   model.
#
#
# === Parameters
#
# [*bucket*]
#   The bucket name to write events to Expansion is supported here as
#   values are passed through event.sprintf Multiple buckets can be
#   specified here but any bucket-specific settings defined apply to ALL
#   the buckets.
#   Value type is array
#   Default value: ["logstash-%{+YYYY.MM.dd}"]
#   This variable is optional
#
# [*bucket_props*]
#   Bucket properties (NYI) Logstash hash of properties for the bucket
#   i.e. bucket_props =&gt; ["r", "one", "w", "one", "dw", "one"] or
#   bucket_props =&gt; ["n_val", "3"] Note that the Logstash config
#   language cannot support hash or array values Properties will be passed
#   as-is
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*enable_search*]
#   Search Enable search on the bucket defined above
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*enable_ssl*]
#   SSL Enable SSL
#   Value type is boolean
#   Default value: false
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
# [*indices*]
#   Indices Array of fields to add 2i on e.g. `indices =&gt;
#   ["@source_host", "@type"] Off by default as not everyone runs eleveldb
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*key_name*]
#   The event key name variables are valid here.  Choose this carefully.
#   Best to let riak decide....
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*nodes*]
#   The nodes of your Riak cluster This can be a single host or a Logstash
#   hash of node/port pairs e.g ["node1", "8098", "node2", "8098"]
#   Value type is hash
#   Default value: {"localhost"=>"8098"}
#   This variable is optional
#
# [*proto*]
#   The protocol to use HTTP or ProtoBuf Applies to ALL backends listed
#   above No mix and match
#   Value can be any of: "http", "pb"
#   Default value: "http"
#   This variable is optional
#
# [*ssl_opts*]
#   SSL Options Options for SSL connections Only applied if SSL is enabled
#   Logstash hash that maps to the riak-client options here:
#   https://github.com/basho/riak-ruby-client/wiki/Connecting-to-Riak
#   You'll likely want something like this: ssl_opts =&gt; ["pem",
#   "/etc/riak.pem", "ca_path", "/usr/share/certificates"] Per the riak
#   client docs, the above sample options will turn on SSLVERIFY_PEER`
#   Value type is hash
#   Default value: None
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
#  http://logstash.net/docs/1.1.9/outputs/riak
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::riak (
  $bucket        = '',
  $bucket_props  = '',
  $enable_search = '',
  $enable_ssl    = '',
  $exclude_tags  = '',
  $fields        = '',
  $indices       = '',
  $key_name      = '',
  $nodes         = '',
  $proto         = '',
  $ssl_opts      = '',
  $tags          = '',
  $type          = ''
) {


  require logstash::params

  #### Validate parameters
  if $bucket {
    validate_array($bucket)
    $arr_bucket = join($bucket, '\', \'')
    $opt_bucket = "  bucket => ['${arr_bucket}']\n"
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

  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $indices {
    validate_array($indices)
    $arr_indices = join($indices, '\', \'')
    $opt_indices = "  indices => ['${arr_indices}']\n"
  }

  if $enable_ssl {
    validate_bool($enable_ssl)
    $opt_enable_ssl = "  enable_ssl => ${enable_ssl}\n"
  }

  if $enable_search {
    validate_bool($enable_search)
    $opt_enable_search = "  enable_search => ${enable_search}\n"
  }

  if $bucket_props {
    validate_hash($bucket_props)
    $arr_bucket_props = inline_template('<%= bucket_props.to_a.flatten.inspect %>')
    $opt_bucket_props = "  bucket_props => ${arr_bucket_props}\n"
  }

  if $nodes {
    validate_hash($nodes)
    $arr_nodes = inline_template('<%= nodes.to_a.flatten.inspect %>')
    $opt_nodes = "  nodes => ${arr_nodes}\n"
  }

  if $ssl_opts {
    validate_hash($ssl_opts)
    $arr_ssl_opts = inline_template('<%= ssl_opts.to_a.flatten.inspect %>')
    $opt_ssl_opts = "  ssl_opts => ${arr_ssl_opts}\n"
  }

  if $proto {
    if ! ($proto in ['http', 'pb']) {
      fail("\"${proto}\" is not a valid proto parameter value")
    } else {
      $opt_proto = "  proto => \"${proto}\"\n"
    }
  }

  if $key_name {
    validate_string($key_name)
    $opt_key_name = "  key_name => \"${key_name}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_riak_${name}":
    ensure  => present,
    content => "output {\n riak {\n${opt_bucket}${opt_bucket_props}${opt_enable_search}${opt_enable_ssl}${opt_exclude_tags}${opt_fields}${opt_indices}${opt_key_name}${opt_nodes}${opt_proto}${opt_ssl_opts}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

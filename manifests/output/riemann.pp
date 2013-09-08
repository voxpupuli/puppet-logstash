# == Define: logstash::output::riemann
#
#   Riemann is a network event stream processing system.  While Riemann is
#   very similar conceptually to Logstash, it has much more in terms of
#   being a monitoring system replacement.  Riemann is used in Logstash
#   much like statsd or other metric-related outputs  You can learn about
#   Riemann here:  http://aphyr.github.com/riemann/ You can see the author
#   talk about it here: http://vimeo.com/38377415
#
#
# === Parameters
#
# [*debug*]
#   Enable debugging output?
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
# [*host*]
#   The address of the Riemann server.
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*port*]
#   The port to connect to on your Riemann server.
#   Value type is number
#   Default value: 5555
#   This variable is optional
#
# [*protocol*]
#   The protocol to use UDP is non-blocking TCP is blocking  Logstash's
#   default output behaviour is to never lose events As such, we use tcp
#   as default here
#   Value can be any of: "tcp", "udp"
#   Default value: "tcp"
#   This variable is optional
#
# [*riemann_event*]
#   A Hash to set Riemann event fields
#   (http://aphyr.github.com/riemann/concepts.html).  The following event
#   fields are supported: description, state, metric, ttl, service
#   Example:  riemann {     riemann_event =&gt; [          "metric",
#   "%{metric}",         "service", "%{service}"     ] }   metric and ttl
#   values will be coerced to a floating point value. Values which cannot
#   be coerced will zero (0.0).  description, by default, will be set to
#   the event message but can be overridden here.
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*sender*]
#   The name of the sender. This sets the host value in the Riemann event
#   Value type is string
#   Default value: "%{@source_host}"
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
#  http://logstash.net/docs/1.1.12/outputs/riemann
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::riemann (
  $debug         = '',
  $exclude_tags  = '',
  $fields        = '',
  $host          = '',
  $port          = '',
  $protocol      = '',
  $riemann_event = '',
  $sender        = '',
  $tags          = '',
  $type          = '',
  $instances     = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_riemann_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/riemann/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_riemann_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/riemann/${name}"

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

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if ($riemann_event != '') {
    validate_hash($riemann_event)
    $var_riemann_event = $riemann_event
    $arr_riemann_event = inline_template('<%= "["+var_riemann_event.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_riemann_event = "  riemann_event => ${arr_riemann_event}\n"
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if ($protocol != '') {
    if ! ($protocol in ['tcp', 'udp']) {
      fail("\"${protocol}\" is not a valid protocol parameter value")
    } else {
      $opt_protocol = "  protocol => \"${protocol}\"\n"
    }
  }

  if ($sender != '') {
    validate_string($sender)
    $opt_sender = "  sender => \"${sender}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n riemann {\n${opt_debug}${opt_exclude_tags}${opt_fields}${opt_host}${opt_port}${opt_protocol}${opt_riemann_event}${opt_sender}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

# == Define: logstash::output::nagios_nsca
#
#   The nagios_nsca output is used for sending passive check results to
#   Nagios through the NSCA protocol.  This is useful if your Nagios
#   server is not the same as the source host from where you want to send
#   logs or alerts. If you only have one server, this output is probably
#   overkill # for you, take a look at the 'nagios' output instead.  Here
#   is a sample config using the nagios_nsca output:  output {
#   nagios_nsca {     # specify the hostname or ip of your nagios server
#   host =&gt; "nagios.example.com"      # specify the port to connect to
#   port =&gt; 5667   } }
#
#
# === Parameters
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
#   The nagios host or IP to send logs to. It should have a NSCA daemon
#   running.
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*nagios_host*]
#   The nagios 'host' you want to submit a passive check result to. This
#   parameter accepts interpolation, e.g. you can use @source_host or
#   other logstash internal variables.
#   Value type is string
#   Default value: "%{@source_host}"
#   This variable is optional
#
# [*nagios_service*]
#   The nagios 'service' you want to submit a passive check result to.
#   This parameter accepts interpolation, e.g. you can use @source_host or
#   other logstash internal variables.
#   Value type is string
#   Default value: "LOGSTASH"
#   This variable is optional
#
# [*nagios_status*]
#   The status to send to nagios. Should be 0 = OK, 1 = WARNING, 2 =
#   CRITICAL, 3 = UNKNOWN
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*port*]
#   The port where the NSCA daemon on the nagios host listens.
#   Value type is number
#   Default value: 5667
#   This variable is optional
#
# [*send_nsca_bin*]
#   The path to the 'send_nsca' binary on the local host.
#   Value type is string
#   Default value: "/usr/sbin/send_nsca"
#   This variable is optional
#
# [*send_nsca_config*]
#   The path to the send_nsca config file on the local host. Leave blank
#   if you don't want to provide a config file.
#   Value type is string
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
#  http://logstash.net/docs/1.1.9/outputs/nagios_nsca
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::nagios_nsca (
  $nagios_status,
  $exclude_tags     = '',
  $host             = '',
  $nagios_host      = '',
  $nagios_service   = '',
  $fields           = '',
  $port             = '',
  $send_nsca_bin    = '',
  $send_nsca_config = '',
  $tags             = '',
  $type             = ''
) {


  require logstash::params

  #### Validate parameters
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

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $port {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if $nagios_status {
    validate_string($nagios_status)
    $opt_nagios_status = "  nagios_status => \"${nagios_status}\"\n"
  }

  if $nagios_service {
    validate_string($nagios_service)
    $opt_nagios_service = "  nagios_service => \"${nagios_service}\"\n"
  }

  if $nagios_host {
    validate_string($nagios_host)
    $opt_nagios_host = "  nagios_host => \"${nagios_host}\"\n"
  }

  if $send_nsca_bin {
    validate_string($send_nsca_bin)
    $opt_send_nsca_bin = "  send_nsca_bin => \"${send_nsca_bin}\"\n"
  }

  if $send_nsca_config {
    validate_string($send_nsca_config)
    $opt_send_nsca_config = "  send_nsca_config => \"${send_nsca_config}\"\n"
  }

  if $host {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_nagios_nsca_${name}":
    ensure  => present,
    content => "output {\n nagios_nsca {\n${opt_exclude_tags}${opt_fields}${opt_host}${opt_nagios_host}${opt_nagios_service}${opt_nagios_status}${opt_port}${opt_send_nsca_bin}${opt_send_nsca_config}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

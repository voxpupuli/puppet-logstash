# == Define: logstash::output::loggly
#
#   Got a loggly account? Use logstash to ship logs to Loggly!  This is
#   most useful so you can use logstash to parse and structure your logs
#   and ship structured, json events to your account at Loggly.  To use
#   this, you'll need to use a Loggly input with type 'http' and 'json
#   logging' enabled.
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
#   The hostname to send logs to. This should target the loggly http input
#   server which is usually "logs.loggly.com"
#   Value type is string
#   Default value: "logs.loggly.com"
#   This variable is optional
#
# [*key*]
#   The loggly http input key to send to. This is usually visible in the
#   Loggly 'Inputs' page as something like this
#   https://logs.hoover.loggly.net/inputs/abcdef12-3456-7890-abcd-ef0123456789
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   \----------&gt;   key   &lt;-------------/   You can use %{foo} field
#   lookups here if you need to pull the api key from the event. This is
#   mainly aimed at multitenant hosting providers who want to offer
#   shipping a customer's logs to that customer's loggly account.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*proto*]
#   Should the log action be sent over https instead of plain http
#   Defaults to https
#   Value type is string
#   Default value: "http"
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
#  http://logstash.net/docs/1.1.9/outputs/loggly
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::loggly (
  $key,
  $exclude_tags = '',
  $host         = '',
  $fields       = '',
  $proto        = '',
  $tags         = '',
  $type         = ''
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

  if $key {
    validate_string($key)
    $opt_key = "  key => \"${key}\"\n"
  }

  if $proto {
    validate_string($proto)
    $opt_proto = "  proto => \"${proto}\"\n"
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

  file { "${logstash::params::configdir}/output_loggly_${name}":
    ensure  => present,
    content => "output {\n loggly {\n${opt_exclude_tags}${opt_fields}${opt_host}${opt_key}${opt_proto}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

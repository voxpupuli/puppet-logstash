# == Define: logstash::output::irc
#
#   Write events to IRC
#
#
# === Parameters
#
# [*channels*]
#   Channels to broadcast to.  These should be full channel names
#   including the '#' symbol, such as "#logstash".
#   Value type is array
#   Default value: None
#   This variable is required
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
# [*format*]
#   Message format to send, event tokens are usable here
#   Value type is string
#   Default value: "%{@message}"
#   This variable is optional
#
# [*host*]
#   Address of the host to connect to
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*nick*]
#   IRC Nickname
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*password*]
#   IRC server password
#   Value type is password
#   Default value: None
#   This variable is optional
#
# [*port*]
#   Port on host to connect to.
#   Value type is number
#   Default value: None
#   This variable is required
#
# [*real*]
#   IRC Real name
#   Value type is string
#   Default value: "logstash"
#   This variable is optional
#
# [*secure*]
#   Set this to true to enable SSL.
#   Value type is boolean
#   Default value: false
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
#   IRC Username
#   Value type is string
#   Default value: "logstash"
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
#  http://logstash.net/docs/1.1.12/outputs/irc
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::irc (
  $channels,
  $host,
  $port,
  $format       = '',
  $fields       = '',
  $nick         = '',
  $password     = '',
  $exclude_tags = '',
  $real         = '',
  $secure       = '',
  $tags         = '',
  $type         = '',
  $user         = '',
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_irc_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/irc/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_irc_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/irc/${name}"

  }

  #### Validate parameters
  if ($channels != '') {
    validate_array($channels)
    $arr_channels = join($channels, '\', \'')
    $opt_channels = "  channels => ['${arr_channels}']\n"
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

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }


  validate_array($instances)

  if ($secure != '') {
    validate_bool($secure)
    $opt_secure = "  secure => ${secure}\n"
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if ($password != '') {
    validate_string($password)
    $opt_password = "  password => \"${password}\"\n"
  }

  if ($format != '') {
    validate_string($format)
    $opt_format = "  format => \"${format}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if ($real != '') {
    validate_string($real)
    $opt_real = "  real => \"${real}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($user != '') {
    validate_string($user)
    $opt_user = "  user => \"${user}\"\n"
  }

  if ($nick != '') {
    validate_string($nick)
    $opt_nick = "  nick => \"${nick}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n irc {\n${opt_channels}${opt_exclude_tags}${opt_fields}${opt_format}${opt_host}${opt_nick}${opt_password}${opt_port}${opt_real}${opt_secure}${opt_tags}${opt_type}${opt_user} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

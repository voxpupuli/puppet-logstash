# == Define: logstash::output::pipe
#
#   Pipe output.  Pipe events to stdin of another program. You can use
#   fields from the event as parts of the command. WARNING: This feature
#   can cause logstash to fork off multiple children if you are not
#   carefull with per-event commandline.
#
#
# === Parameters
#
# [*command*]
#   Command line to launch and pipe to
#   Value type is string
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
# [*message_format*]
#   The format to use when writing events to the pipe. This value supports
#   any string and can include %{name} and other dynamic strings.  If this
#   setting is omitted, the full json representation of the event will be
#   written as a single line.
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
# [*ttl*]
#   Close pipe that hasn't been used for TTL seconds. -1 or 0 means never
#   close.
#   Value type is number
#   Default value: 10
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
#  http://logstash.net/docs/1.1.9/outputs/pipe
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::pipe (
  $command,
  $message_format = '',
  $fields         = '',
  $exclude_tags   = '',
  $tags           = '',
  $ttl            = '',
  $type           = ''
) {


  require logstash::params

  #### Validate parameters
  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $fields {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if $ttl {
    if ! is_numeric($ttl) {
      fail("\"${ttl}\" is not a valid ttl parameter value")
    } else {
      $opt_ttl = "  ttl => ${ttl}\n"
    }
  }

  if $message_format {
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if $command {
    validate_string($command)
    $opt_command = "  command => \"${command}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_pipe_${name}":
    ensure  => present,
    content => "output {\n pipe {\n${opt_command}${opt_exclude_tags}${opt_fields}${opt_message_format}${opt_tags}${opt_ttl}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

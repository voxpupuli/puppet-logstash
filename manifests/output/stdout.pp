# == Define: logstash::output::stdout
#
#
#
# === Parameters
#
# [*debug*]
#   Enable debugging. Tries to pretty-print the entire event object.
#   Value type is boolean
#   Default value: None
#   This variable is optional
#
# [*debug_format*]
#   Debug output format: ruby (default), json
#   Value can be any of: "ruby", "json", "dots"
#   Default value: "ruby"
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
# [*message*]
#   The message to emit to stdout.
#   Value type is string
#   Default value: "%{@timestamp} %{@source}: %{@message}"
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
#  http://logstash.net/docs/1.1.12/outputs/stdout
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::stdout (
  $debug        = '',
  $debug_format = '',
  $exclude_tags = '',
  $fields       = '',
  $message      = '',
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
    $conffiles    = suffix($confdirstart, "/config/output_stdout_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/stdout/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_stdout_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/stdout/${name}"

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

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if ($debug_format != '') {
    if ! ($debug_format in ['ruby', 'json', 'dots']) {
      fail("\"${debug_format}\" is not a valid debug_format parameter value")
    } else {
      $opt_debug_format = "  debug_format => \"${debug_format}\"\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($message != '') {
    validate_string($message)
    $opt_message = "  message => \"${message}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n stdout {\n${opt_debug}${opt_debug_format}${opt_exclude_tags}${opt_fields}${opt_message}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

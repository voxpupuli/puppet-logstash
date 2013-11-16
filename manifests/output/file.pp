# == Define: logstash::output::file
#
#   File output.  Write events to files on disk. You can use fields from
#   the event as parts of the filename.
#
#
# === Parameters
#
# [*codec*]
#   A codec value.  It is recommended that you use the logstash_codec function
#   to derive this variable. Example: logstash_codec('graphite', {'charset' => 'UTF-8'})
#   but you could just pass a string, Example: "graphite{ charset => 'UTF-8' }"
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*conditional*]
#   Surrounds the rule with a conditional.  It is recommended that you use the
#   logstash_conditional function, Example: logstash_conditional('[type] == "apache"')
#   or, Example: logstash_conditional(['[loglevel] == "ERROR"','[deployment] == "production"'], 'or')
#   but you could just pass a string, Example: '[loglevel] == "ERROR" or [deployment] == "production"'
#   Value type is string
#   Default value: None
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
# [*flush_interval*]
#   Flush interval for flushing writes to log files. 0 will flush on every
#   meesage
#   Value type is number
#   Default value: 2
#   This variable is optional
#
# [*gzip*]
#   Gzip output stream
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*max_size*]
#   The maximum size of file to write. When the file exceeds this
#   threshold, it will be rotated to the current filename + ".1" If that
#   file already exists, the previous .1 will shift to .2 and so forth.
#   NOT YET SUPPORTED
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*message_format*]
#   The format to use when writing events to the file. This value supports
#   any string and can include %{name} and other dynamic strings.  If this
#   setting is omitted, the full json representation of the event will be
#   written as a single line.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*path*]
#   The path to the file to write. Event fields can be used here, like
#   "/var/log/logstash/%{@source_host}/%{application}"
#   Value type is string
#   Default value: None
#   This variable is required
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
#  This define is created based on LogStash version 1.2.2
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.2.2/outputs/file
#
#  Need help? http://logstash.net/docs/1.2.2/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
# === Contributors
#
# * Luke Chavers <mailto:vmadman@gmail.com> - Added Initial Logstash 1.2.x Support
#
define logstash::output::file (
  $path,
  $message_format = '',
  $flush_interval = '',
  $gzip           = '',
  $max_size       = '',
  $fields         = '',
  $exclude_tags   = '',
  $tags           = '',
  $type           = '',
  $codec          = '',
  $conditional    = '',
  $instances      = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_file_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/file/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_file_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/file/${name}"

  }

  #### Validate parameters

  if ($conditional != '') {
    validate_string($conditional)
    $opt_indent = "   "
    $opt_cond_start = " ${conditional}\n "
    $opt_cond_end = "  }\n "
  } else {
    $opt_indent = "  "
    $opt_cond_end = " "
  }

  if ($codec != '') {
    validate_string($codec)
    $opt_codec = "${opt_indent}codec => ${codec}\n"
  }


  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "${opt_indent}exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "${opt_indent}fields => ['${arr_fields}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "${opt_indent}tags => ['${arr_tags}']\n"
  }


  validate_array($instances)

  if ($gzip != '') {
    validate_bool($gzip)
    $opt_gzip = "${opt_indent}gzip => ${gzip}\n"
  }

  if ($flush_interval != '') {
    if ! is_numeric($flush_interval) {
      fail("\"${flush_interval}\" is not a valid flush_interval parameter value")
    } else {
      $opt_flush_interval = "${opt_indent}flush_interval => ${flush_interval}\n"
    }
  }

  if ($max_size != '') {
    validate_string($max_size)
    $opt_max_size = "${opt_indent}max_size => \"${max_size}\"\n"
  }

  if ($path != '') {
    validate_string($path)
    $opt_path = "${opt_indent}path => \"${path}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n${opt_cond_start} file {\n${opt_exclude_tags}${opt_fields}${opt_codec}${opt_flush_interval}${opt_gzip}${opt_max_size}${opt_message_format}${opt_path}${opt_tags}${opt_type}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

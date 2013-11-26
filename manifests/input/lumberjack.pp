# == Define: logstash::input::lumberjack
#
#   Receive events using the lumberjack protocol.  This is mainly to
#   receive events shipped  with lumberjack,
#   http://github.com/jordansissel/lumberjack
#
#
# === Parameters
#
# [*add_field*]
#   Add a field to an event
#   Value type is hash
#   Default value: {}
#   This variable is optional
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
#   but you could just pass a string, Example: 'if [loglevel] == "ERROR" or [deployment] == "production" {'
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*debug*]
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*host*]
#   the address to listen on.
#   Value type is string
#   Default value: "0.0.0.0"
#   This variable is optional
#
# [*port*]
#   the port to listen on.
#   Value type is number
#   Default value: None
#   This variable is required
#
# [*ssl_certificate*]
#   ssl certificate to use
#   Value type is path
#   Default value: None
#   This variable is required
#
# [*ssl_key*]
#   ssl key to use
#   Value type is path
#   Default value: None
#   This variable is required
#
# [*ssl_key_passphrase*]
#   ssl key passphrase to use
#   Value type is password
#   Default value: None
#   This variable is optional
#
# [*tags*]
#   Add any number of arbitrary tags to your event.  This can help with
#   processing later.
#   Value type is array
#   Default value: None
#   This variable is optional
#
# [*type*]
#   Label this input with a type. Types are used mainly for filter
#   activation.  If you create an input with type "foobar", then only
#   filters which also have type "foobar" will act on them.  The type is
#   also stored as part of the event itself, so you can also use the type
#   to search for in the web interface.  If you try to set a type on an
#   event that already has one (for example when you send an event from a
#   shipper to an indexer) then a new input will not override the existing
#   type. A type set at the shipper stays with that event for its life
#   even when sent to another LogStash server.
#   Value type is string
#   Default value: None
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
#  Extra information about this input can be found at:
#  http://logstash.net/docs/1.2.2/inputs/lumberjack
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
define logstash::input::lumberjack (
  $port,
  $type,
  $ssl_key,
  $ssl_certificate,
  $add_field          = '',
  $codec              = '',
  $conditional        = '',
  $host               = '',
  $debug              = '',
  $ssl_key_passphrase = '',
  $tags               = '',
  $charset            = '',
  $instances          = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_lumberjack_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/lumberjack/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_lumberjack_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/lumberjack/${name}"

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

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "${opt_indent}tags => ['${arr_tags}']\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "${opt_indent}debug => ${debug}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "${opt_indent}add_field => ${arr_add_field}\n"
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "${opt_indent}port => ${port}\n"
    }
  }

  if ($ssl_key_passphrase != '') {
    validate_string($ssl_key_passphrase)
    $opt_ssl_key_passphrase = "${opt_indent}ssl_key_passphrase => \"${ssl_key_passphrase}\"\n"
  }

  if ($ssl_certificate != '') {
    if $ssl_certificate =~ /^puppet\:\/\// {

      validate_re($ssl_certificate, '\Apuppet:\/\/')

      $filenameArray_ssl_certificate = split($ssl_certificate, '/')
      $basefilename_ssl_certificate = $filenameArray_ssl_certificate[-1]

      $opt_ssl_certificate = "${opt_indent}ssl_certificate => \"${filesdir}/${basefilename_ssl_certificate}\"\n"

      file { "${filesdir}/${basefilename_ssl_certificate}":
        source  => $ssl_certificate,
        mode    => '0440',
        require => File[$filesdir]
      }
    } else {
      $opt_ssl_certificate = "${opt_indent}ssl_certificate => \"${ssl_certificate}\"\n"
    }
  }

  if ($ssl_key != '') {
    if $ssl_key =~ /^puppet\:\/\// {

      validate_re($ssl_key, '\Apuppet:\/\/')

      $filenameArray_ssl_key = split($ssl_key, '/')
      $basefilename_ssl_key = $filenameArray_ssl_key[-1]

      $opt_ssl_key = "${opt_indent}ssl_key => \"${filesdir}/${basefilename_ssl_key}\"\n"

      file { "${filesdir}/${basefilename_ssl_key}":
        source  => $ssl_key,
        mode    => '0440',
        require => File[$filesdir]
      }
    } else {
      $opt_ssl_key = "${opt_indent}ssl_key => \"${ssl_key}\"\n"
    }
  }

  if ($message_format != '') {
    validate_string($message_format)
    $opt_message_format = "${opt_indent}message_format => \"${message_format}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "${opt_indent}host => \"${host}\"\n"
  }


  #### Create the directory where we place the files
  exec { "create_files_dir_input_lumberjack_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${filesdir}",
    creates => $filesdir
  }

  #### Manage the files directory
  file { $filesdir:
    ensure  => directory,
    mode    => '0640',
    purge   => true,
    recurse => true,
    require => Exec["create_files_dir_input_lumberjack_${name}"],
    notify  => Service[$services]
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n${opt_cond_start} lumberjack {\n${opt_add_field}${opt_debug}${opt_host}${opt_codec}${opt_port}${opt_ssl_certificate}${opt_ssl_key}${opt_ssl_key_passphrase}${opt_tags}${opt_type}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

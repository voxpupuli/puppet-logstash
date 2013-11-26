# == Define: logstash::input::imap
#
#   Read mail from IMAP servers  Periodically scans INBOX and moves any
#   read messages to the trash.
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
# [*check_interval*]
#   Value type is number
#   Default value: 300
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
# [*fetch_count*]
#   Value type is number
#   Default value: 50
#   This variable is optional
#
# [*host*]
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*lowercase_headers*]
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*password*]
#   Value type is password
#   Default value: None
#   This variable is required
#
# [*port*]
#   Value type is number
#   Default value: None
#   This variable is optional
#
# [*secure*]
#   Value type is boolean
#   Default value: true
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
# [*user*]
#   Value type is string
#   Default value: None
#   This variable is required
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
#  http://logstash.net/docs/1.2.2/inputs/imap
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
define logstash::input::imap (
  $host,
  $user,
  $type,
  $password,
  $codec             = '',
  $conditional       = '',
  $add_field         = '',
  $lowercase_headers = '',
  $fetch_count       = '',
  $debug             = '',
  $port              = '',
  $secure            = '',
  $tags              = '',
  $check_interval    = '',
  $charset           = '',
  $instances         = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_imap_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/imap/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_imap_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/imap/${name}"

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

  if ($secure != '') {
    validate_bool($secure)
    $opt_secure = "${opt_indent}secure => ${secure}\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "${opt_indent}debug => ${debug}\n"
  }

  if ($lowercase_headers != '') {
    validate_bool($lowercase_headers)
    $opt_lowercase_headers = "${opt_indent}lowercase_headers => ${lowercase_headers}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "${opt_indent}add_field => ${arr_add_field}\n"
  }

  if ($check_interval != '') {
    if ! is_numeric($check_interval) {
      fail("\"${check_interval}\" is not a valid check_interval parameter value")
    } else {
      $opt_check_interval = "${opt_indent}check_interval => ${check_interval}\n"
    }
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "${opt_indent}port => ${port}\n"
    }
  }

  if ($fetch_count != '') {
    if ! is_numeric($fetch_count) {
      fail("\"${fetch_count}\" is not a valid fetch_count parameter value")
    } else {
      $opt_fetch_count = "${opt_indent}fetch_count => ${fetch_count}\n"
    }
  }

  if ($password != '') {
    validate_string($password)
    $opt_password = "${opt_indent}password => \"${password}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "${opt_indent}host => \"${host}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  if ($user != '') {
    validate_string($user)
    $opt_user = "${opt_indent}user => \"${user}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n${opt_cond_start} imap {\n${opt_add_field}${opt_check_interval}${opt_debug}${opt_fetch_count}${opt_host}${opt_lowercase_headers}${opt_codec}${opt_password}${opt_port}${opt_secure}${opt_tags}${opt_type}${opt_user}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

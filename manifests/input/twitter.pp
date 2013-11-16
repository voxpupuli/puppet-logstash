# == Define: logstash::input::twitter
#
#   Read events from the twitter streaming api.
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
#   but you could just pass a string, Example: '[loglevel] == "ERROR" or [deployment] == "production"'
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
# [*keywords*]
#   Any keywords to track in the twitter stream
#   Value type is array
#   Default value: None
#   This variable is required
#
# [*password*]
#   Your twitter password
#   Value type is password
#   Default value: None
#   This variable is required
#
# [*proxy_host*]
#   Proxy Host
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*proxy_password*]
#   Proxy Password
#   Value type is password
#   Default value: None
#   This variable is optional
#
# [*proxy_port*]
#   Proxy Port
#   Value type is number
#   Default value: None
#   This variable is optional
#
# [*proxy_user*]
#   Proxy Username
#   Value type is string
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
# [*user*]
#   Your twitter username
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
#  http://logstash.net/docs/1.2.2/inputs/twitter
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
define logstash::input::twitter (
  $keywords,
  $user,
  $type,
  $password,
  $proxy_host     = '',
  $codec          = '',
  $conditional    = '',
  $add_field      = '',
  $proxy_password = '',
  $proxy_port     = '',
  $proxy_user     = '',
  $tags           = '',
  $debug          = '',
  $instances      = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_twitter_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/twitter/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_twitter_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/twitter/${name}"

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

  if ($keywords != '') {
    validate_array($keywords)
    $arr_keywords = join($keywords, '\', \'')
    $opt_keywords = "${opt_indent}keywords => ['${arr_keywords}']\n"
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

  if ($proxy_port != '') {
    if ! is_numeric($proxy_port) {
      fail("\"${proxy_port}\" is not a valid proxy_port parameter value")
    } else {
      $opt_proxy_port = "${opt_indent}proxy_port => ${proxy_port}\n"
    }
  }

  if ($proxy_password != '') {
    validate_string($proxy_password)
    $opt_proxy_password = "${opt_indent}proxy_password => \"${proxy_password}\"\n"
  }

  if ($password != '') {
    validate_string($password)
    $opt_password = "${opt_indent}password => \"${password}\"\n"
  }

  if ($proxy_user != '') {
    validate_string($proxy_user)
    $opt_proxy_user = "${opt_indent}proxy_user => \"${proxy_user}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  if ($user != '') {
    validate_string($user)
    $opt_user = "${opt_indent}user => \"${user}\"\n"
  }

  if ($proxy_host != '') {
    validate_string($proxy_host)
    $opt_proxy_host = "${opt_indent}proxy_host => \"${proxy_host}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n${opt_cond_start} twitter {\n${opt_add_field}${opt_debug}${opt_keywords}${opt_codec}${opt_password}${opt_proxy_host}${opt_proxy_password}${opt_proxy_port}${opt_proxy_user}${opt_tags}${opt_type}${opt_user}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

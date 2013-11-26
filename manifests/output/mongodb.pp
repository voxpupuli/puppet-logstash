# == Define: logstash::output::mongodb
#
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
#   but you could just pass a string, Example: 'if [loglevel] == "ERROR" or [deployment] == "production" {'
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*collection*]
#   The collection to use. This value can use %{foo} values to dynamically
#   select a collection based on data in the event.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*database*]
#   The database to use
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
# [*host*]
#   your mongodb host
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*isodate*]
#   If true, store the @timestamp field in mongodb as an ISODate type
#   instead of an ISO8601 string.  For more information about this, see
#   http://www.mongodb.org/display/DOCS/Dates
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*password*]
#   Value type is password
#   Default value: None
#   This variable is optional
#
# [*port*]
#   the mongodb port
#   Value type is number
#   Default value: 27017
#   This variable is optional
#
# [*retry_delay*]
#   Number of seconds to wait after failure before retrying
#   Value type is number
#   Default value: 3
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
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.2.2/outputs/mongodb
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
define logstash::output::mongodb (
  $collection,
  $database,
  $host,
  $password     = '',
  $exclude_tags = '',
  $isodate      = '',
  $fields       = '',
  $port         = '',
  $retry_delay  = '',
  $tags         = '',
  $type         = '',
  $user         = '',
  $codec        = '',
  $conditional  = '',
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_mongodb_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/mongodb/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_mongodb_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/mongodb/${name}"

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

  if ($isodate != '') {
    validate_bool($isodate)
    $opt_isodate = "${opt_indent}isodate => ${isodate}\n"
  }

  if ($retry_delay != '') {
    if ! is_numeric($retry_delay) {
      fail("\"${retry_delay}\" is not a valid retry_delay parameter value")
    } else {
      $opt_retry_delay = "${opt_indent}retry_delay => ${retry_delay}\n"
    }
  }

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "${opt_indent}port => ${port}\n"
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

  if ($database != '') {
    validate_string($database)
    $opt_database = "${opt_indent}database => \"${database}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  if ($user != '') {
    validate_string($user)
    $opt_user = "${opt_indent}user => \"${user}\"\n"
  }

  if ($collection != '') {
    validate_string($collection)
    $opt_collection = "${opt_indent}collection => \"${collection}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n${opt_cond_start} mongodb {\n${opt_collection}${opt_database}${opt_exclude_tags}${opt_fields}${opt_codec}${opt_host}${opt_isodate}${opt_password}${opt_port}${opt_retry_delay}${opt_tags}${opt_type}${opt_user}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

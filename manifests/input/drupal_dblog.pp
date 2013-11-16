# == Define: logstash::input::drupal_dblog
#
#   Retrieve watchdog log events from a Drupal installation with DBLog
#   enabled. The events are pulled out directly from the database. The
#   original events are not deleted, and on every consecutive run only new
#   events are pulled.  The last watchdog event id that was processed is
#   stored in the Drupal variable table with the name "logstashlastwid".
#   Delete this variable or set it to 0 if you want to re-import all
#   events.  More info on DBLog:
#   http://drupal.org/documentation/modules/dblog
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
# [*add_usernames*]
#   By default, the event only contains the current user id as a field. If
#   you whish to add the username as an additional field, set this to
#   true.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*bulksize*]
#   The amount of log messages that should be fetched with each query.
#   Bulk fetching is done to prevent querying huge data sets when lots of
#   messages are in the database.
#   Value type is number
#   Default value: 5000
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
# [*databases*]
#   Specify all drupal databases that you whish to import from. This can
#   be as many as you whish. The format is a hash, with a unique site name
#   as the key, and a databse url as the value.  Example: [   "site1",
#   "mysql://user1:password@host1.com/databasename",   "other_site",
#   "mysql://user2:password@otherhost.com/databasename",   ... ]
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*debug*]
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*interval*]
#   Time between checks in minutes.
#   Value type is number
#   Default value: 10
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
#   to search for in the web interface.
#   Value type is string
#   Default value: "watchdog"
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
#  http://logstash.net/docs/1.2.2/inputs/drupal_dblog
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
define logstash::input::drupal_dblog (
  $add_field      = '',
  $add_usernames  = '',
  $bulksize       = '',
  $databases      = '',
  $debug          = '',
  $interval       = '',
  $codec          = '',
  $conditional    = '',
  $tags           = '',
  $type           = '',
  $instances      = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_drupal_dblog_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/drupal_dblog/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_drupal_dblog_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/drupal_dblog/${name}"

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

  if ($add_usernames != '') {
    validate_bool($add_usernames)
    $opt_add_usernames = "${opt_indent}add_usernames => ${add_usernames}\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "${opt_indent}debug => ${debug}\n"
  }

  if ($databases != '') {
    validate_hash($databases)
    $var_databases = $databases
    $arr_databases = inline_template('<%= "["+var_databases.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_databases = "${opt_indent}databases => ${arr_databases}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "${opt_indent}add_field => ${arr_add_field}\n"
  }

  if ($bulksize != '') {
    if ! is_numeric($bulksize) {
      fail("\"${bulksize}\" is not a valid bulksize parameter value")
    } else {
      $opt_bulksize = "${opt_indent}bulksize => ${bulksize}\n"
    }
  }

  if ($interval != '') {
    if ! is_numeric($interval) {
      fail("\"${interval}\" is not a valid interval parameter value")
    } else {
      $opt_interval = "${opt_indent}interval => ${interval}\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "${opt_indent}type => \"${type}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n${opt_cond_start} drupal_dblog {\n${opt_add_field}${opt_codec}${opt_add_usernames}${opt_bulksize}${opt_databases}${opt_debug}${opt_interval}${opt_tags}${opt_type}${opt_cond_end}}\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

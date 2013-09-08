# == Define: logstash::output::nagios
#
#   The nagios output is used for sending passive check results to nagios
#   via the nagios command file.  For this output to work, your event must
#   have the following fields:  "nagios_host" "nagios_service" These
#   fields are supported, but optional:  "nagios_annotation"
#   "nagios_level" There are two configuration options:  commandfile - The
#   location of the Nagios external command file nagioslevel - Specifies
#   the level of the check to be sent. Defaults to CRITICAL and can be
#   overriden by setting the "nagioslevel" field to one of "OK",
#   "WARNING", "CRITICAL", or "UNKNOWN" The easiest way to use this output
#   is with the grep filter. Presumably, you only want certain events
#   matching a given pattern to send events to nagios. So use grep to
#   match and also to add the required fields.  filter {   grep {     type
#   =&gt; "linux-syslog"     match =&gt; [ "@message",
#   "(error|ERROR|CRITICAL)" ]     add_tag =&gt; [ "nagios-update" ]
#   add_field =&gt; [       "nagios_host", "%{@source_host}",
#   "nagios_service", "the name of your nagios service check"     ]   } }
#   output{   nagios {     # only process events with this tag     tags
#   =&gt; "nagios-update"   } }
#
#
# === Parameters
#
# [*commandfile*]
#   The path to your nagios command file
#   Value type is path
#   Default value: "/var/lib/nagios3/rw/nagios.cmd"
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
# [*nagios_level*]
#   The Nagios check level. Should be one of 0=OK, 1=WARNING, 2=CRITICAL,
#   3=UNKNOWN. Defaults to 2 - CRITICAL.
#   Value can be any of: "0", "1", "2", "3"
#   Default value: "2"
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
#  http://logstash.net/docs/1.1.12/outputs/nagios
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::nagios (
  $commandfile  = '',
  $exclude_tags = '',
  $fields       = '',
  $nagios_level = '',
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
    $conffiles    = suffix($confdirstart, "/config/output_nagios_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/nagios/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_nagios_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/nagios/${name}"

  }

  #### Validate parameters

  validate_array($instances)

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

  if ($nagios_level != '') {
    if ! ($nagios_level in ['0', '1', '2', '3']) {
      fail("\"${nagios_level}\" is not a valid nagios_level parameter value")
    } else {
      $opt_nagios_level = "  nagios_level => \"${nagios_level}\"\n"
    }
  }

  if ($commandfile != '') {
    if $commandfile =~ /^puppet\:\/\// {

      validate_re($commandfile, '\Apuppet:\/\/')

      $filenameArray_commandfile = split($commandfile, '/')
      $basefilename_commandfile = $filenameArray_commandfile[-1]

      $opt_commandfile = "  commandfile => \"${filesdir}/${basefilename_commandfile}\"\n"

      file { "${filesdir}/${basefilename_commandfile}":
        source  => $commandfile,
        mode    => '0440',
        require => File[$filesdir]
      }
    } else {
      $opt_commandfile = "  commandfile => \"${commandfile}\"\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }


  #### Create the directory where we place the files
  exec { "create_files_dir_output_nagios_${name}":
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
    require => Exec["create_files_dir_output_nagios_${name}"],
    notify  => Service[$services]
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n nagios {\n${opt_commandfile}${opt_exclude_tags}${opt_fields}${opt_nagios_level}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

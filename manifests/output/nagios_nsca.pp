# == Define: logstash::output::nagios_nsca
#
#   The nagios_nsca output is used for sending passive check results to
#   Nagios through the NSCA protocol.  This is useful if your Nagios
#   server is not the same as the source host from where you want to send
#   logs or alerts. If you only have one server, this output is probably
#   overkill # for you, take a look at the 'nagios' output instead.  Here
#   is a sample config using the nagios_nsca output:  output {
#   nagios_nsca {     # specify the hostname or ip of your nagios server
#   host =&gt; "nagios.example.com"      # specify the port to connect to
#   port =&gt; 5667   } }
#
#
# === Parameters
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
#   The nagios host or IP to send logs to. It should have a NSCA daemon
#   running.
#   Value type is string
#   Default value: "localhost"
#   This variable is optional
#
# [*message_format*]
#   The format to use when writing events to nagios. This value supports
#   any string and can include %{name} and other dynamic strings.
#   Value type is string
#   Default value: "%{@timestamp} %{@source}: %{@message}"
#   This variable is optional
#
# [*nagios_host*]
#   The nagios 'host' you want to submit a passive check result to. This
#   parameter accepts interpolation, e.g. you can use @source_host or
#   other logstash internal variables.
#   Value type is string
#   Default value: "%{@source_host}"
#   This variable is optional
#
# [*nagios_service*]
#   The nagios 'service' you want to submit a passive check result to.
#   This parameter accepts interpolation, e.g. you can use @source_host or
#   other logstash internal variables.
#   Value type is string
#   Default value: "LOGSTASH"
#   This variable is optional
#
# [*nagios_status*]
#   The status to send to nagios. Should be 0 = OK, 1 = WARNING, 2 =
#   CRITICAL, 3 = UNKNOWN
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*port*]
#   The port where the NSCA daemon on the nagios host listens.
#   Value type is number
#   Default value: 5667
#   This variable is optional
#
# [*send_nsca_bin*]
#   The path to the 'send_nsca' binary on the local host.
#   Value type is path
#   Default value: "/usr/sbin/send_nsca"
#   This variable is optional
#
# [*send_nsca_config*]
#   The path to the send_nsca config file on the local host. Leave blank
#   if you don't want to provide a config file.
#   Value type is path
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
#  http://logstash.net/docs/1.1.12/outputs/nagios_nsca
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::nagios_nsca (
  $nagios_status,
  $exclude_tags     = '',
  $host             = '',
  $message_format   = '',
  $nagios_host      = '',
  $nagios_service   = '',
  $fields           = '',
  $port             = '',
  $send_nsca_bin    = '',
  $send_nsca_config = '',
  $tags             = '',
  $type             = '',
  $instances        = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_nagios_nsca_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/nagios_nsca/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_nagios_nsca_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/nagios_nsca/${name}"

  }

  #### Validate parameters
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

  if ($port != '') {
    if ! is_numeric($port) {
      fail("\"${port}\" is not a valid port parameter value")
    } else {
      $opt_port = "  port => ${port}\n"
    }
  }

  if ($send_nsca_config != '') {
    if $send_nsca_config =~ /^puppet\:\/\// {

      validate_re($send_nsca_config, '\Apuppet:\/\/')

      $filenameArray_send_nsca_config = split($send_nsca_config, '/')
      $basefilename_send_nsca_config = $filenameArray_send_nsca_config[-1]

      $opt_send_nsca_config = "  send_nsca_config => \"${filesdir}/${basefilename_send_nsca_config}\"\n"

      file { "${filesdir}/${basefilename_send_nsca_config}":
        source  => $send_nsca_config,
        mode    => '0440',
        require => File[$filesdir]
      }
    } else {
      $opt_send_nsca_config = "  send_nsca_config => \"${send_nsca_config}\"\n"
    }
  }

  if ($send_nsca_bin != '') {
    if $send_nsca_bin =~ /^puppet\:\/\// {

      validate_re($send_nsca_bin, '\Apuppet:\/\/')

      $filenameArray_send_nsca_bin = split($send_nsca_bin, '/')
      $basefilename_send_nsca_bin = $filenameArray_send_nsca_bin[-1]

      $opt_send_nsca_bin = "  send_nsca_bin => \"${filesdir}/${basefilename_send_nsca_bin}\"\n"

      file { "${filesdir}/${basefilename_send_nsca_bin}":
        source  => $send_nsca_bin,
        mode    => '0440',
        require => File[$filesdir]
      }
    } else {
      $opt_send_nsca_bin = "  send_nsca_bin => \"${send_nsca_bin}\"\n"
    }
  }

  if ($nagios_host != '') {
    validate_string($nagios_host)
    $opt_nagios_host = "  nagios_host => \"${nagios_host}\"\n"
  }

  if ($message_format != '') {
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if ($nagios_service != '') {
    validate_string($nagios_service)
    $opt_nagios_service = "  nagios_service => \"${nagios_service}\"\n"
  }

  if ($host != '') {
    validate_string($host)
    $opt_host = "  host => \"${host}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($nagios_status != '') {
    validate_string($nagios_status)
    $opt_nagios_status = "  nagios_status => \"${nagios_status}\"\n"
  }


  #### Create the directory where we place the files
  exec { "create_files_dir_output_nagios_nsca_${name}":
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
    require => Exec["create_files_dir_output_nagios_nsca_${name}"],
    notify  => Service[$services]
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n nagios_nsca {\n${opt_exclude_tags}${opt_fields}${opt_host}${opt_message_format}${opt_nagios_host}${opt_nagios_service}${opt_nagios_status}${opt_port}${opt_send_nsca_bin}${opt_send_nsca_config}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

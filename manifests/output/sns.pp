# == Define: logstash::output::sns
#
#   SNS output.  Send events to Amazon's Simple Notification Service, a
#   hosted pub/sub framework.  It supports subscribers of type email,
#   HTTP/S, SMS, and SQS.  For further documentation about the service
#   see:    http://docs.amazonwebservices.com/sns/latest/api/  This plugin
#   looks for the following fields on events it receives:  sns - If no ARN
#   is found in the configuration file, this will be used as the ARN to
#   publish. snssubject - The subject line that should be used. Optional.
#   The "%{@source}" will be used if not present and truncated at
#   MAXSUBJECTSIZEIN_CHARACTERS. snsmessage - The message that should be
#   sent. Optional. The event serialzed as JSON will be used if not
#   present and with the @message truncated so that the length of the JSON
#   fits in MAXMESSAGESIZEIN_BYTES.
#
#
# === Parameters
#
# [*access_key_id*]
#   Amazon API credentials.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*arn*]
#   SNS topic ARN.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*credentials*]
#   Path to YAML file containing a hash of AWS credentials.  This file
#   will be loaded if access_key_id and secret_access_key aren't set. The
#   contents of the file should look like this:  --- :access_key_id:
#   "12345" :secret_access_key: "54321"
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
# [*format*]
#   Message format.  Defaults to plain text.
#   Value can be any of: "json", "plain"
#   Default value: "plain"
#   This variable is optional
#
# [*publish_boot_message_arn*]
#   When an ARN for an SNS topic is specified here, the message "Logstash
#   successfully booted" will be sent to it when this plugin is
#   registered.  Example:
#   arn:aws:sns:us-east-1:770975001275:logstash-testing
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*secret_access_key*]
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
#  http://logstash.net/docs/1.1.9/outputs/sns
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::sns (
  $access_key_id            = '',
  $arn                      = '',
  $credentials              = '',
  $exclude_tags             = '',
  $fields                   = '',
  $format                   = '',
  $publish_boot_message_arn = '',
  $secret_access_key        = '',
  $tags                     = '',
  $type                     = ''
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

  if $format {
    if ! ($format in ['json', 'plain']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if $access_key_id {
    validate_string($access_key_id)
    $opt_access_key_id = "  access_key_id => \"${access_key_id}\"\n"
  }

  if $credentials {
    validate_string($credentials)
    $opt_credentials = "  credentials => \"${credentials}\"\n"
  }

  if $publish_boot_message_arn {
    validate_string($publish_boot_message_arn)
    $opt_publish_boot_message_arn = "  publish_boot_message_arn => \"${publish_boot_message_arn}\"\n"
  }

  if $secret_access_key {
    validate_string($secret_access_key)
    $opt_secret_access_key = "  secret_access_key => \"${secret_access_key}\"\n"
  }

  if $arn {
    validate_string($arn)
    $opt_arn = "  arn => \"${arn}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_sns_${name}":
    ensure  => present,
    content => "output {\n sns {\n${opt_access_key_id}${opt_arn}${opt_credentials}${opt_exclude_tags}${opt_fields}${opt_format}${opt_publish_boot_message_arn}${opt_secret_access_key}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

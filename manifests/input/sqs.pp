# == Define: logstash::input::sqs
#
#   Pull events from an Amazon Web Services Simple Queue Service (SQS)
#   queue.  SQS is a simple, scalable queue system that is part of the
#   Amazon Web Services suite of tools.  Although SQS is similar to other
#   queuing systems like AMQP, it uses a custom API and requires that you
#   have an AWS account. See http://aws.amazon.com/sqs/ for more details
#   on how SQS works, what the pricing schedule looks like and how to
#   setup a queue.  To use this plugin, you must:  Have an AWS account
#   Setup an SQS queue Create an identify that has access to consume
#   messages from the queue. The "consumer" identity must have the
#   following permissions on the queue:  sqs:ChangeMessageVisibility
#   sqs:ChangeMessageVisibilityBatch sqs:DeleteMessage
#   sqs:DeleteMessageBatch sqs:GetQueueAttributes sqs:GetQueueUrl
#   sqs:ListQueues sqs:ReceiveMessage Typically, you should setup an IAM
#   policy, create a user and apply the IAM policy to the user. A sample
#   policy is as follows:  {   "Statement": [     {       "Action": [
#   "sqs:ChangeMessageVisibility",
#   "sqs:ChangeMessageVisibilityBatch",         "sqs:GetQueueAttributes",
#   "sqs:GetQueueUrl",         "sqs:ListQueues",
#   "sqs:SendMessage",         "sqs:SendMessageBatch"       ],
#   "Effect": "Allow",       "Resource": [
#   "arn:aws:sqs:us-east-1:123456789012:Logstash"       ]     }   ] }
#   See http://aws.amazon.com/iam/ for more details on setting up AWS
#   identities.
#
#
# === Parameters
#
# [*access_key_id*]
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*add_field*]
#   Add a field to an event
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*aws_credentials_file*]
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*charset*]
#   The character encoding used in this input. Examples include "UTF-8"
#   and "cp1252"  This setting is useful if your log files are in Latin-1
#   (aka cp1252) or in another character set other than UTF-8.  This only
#   affects "plain" format logs since json is UTF-8 already.
#   Value can be any of: "ASCII-8BIT", "UTF-8", "US-ASCII", "Big5",
#   "Big5-HKSCS", "Big5-UAO", "CP949", "Emacs-Mule", "EUC-JP", "EUC-KR",
#   "EUC-TW", "GB18030", "GBK", "ISO-8859-1", "ISO-8859-2", "ISO-8859-3",
#   "ISO-8859-4", "ISO-8859-5", "ISO-8859-6", "ISO-8859-7", "ISO-8859-8",
#   "ISO-8859-9", "ISO-8859-10", "ISO-8859-11", "ISO-8859-13",
#   "ISO-8859-14", "ISO-8859-15", "ISO-8859-16", "KOI8-R", "KOI8-U",
#   "Shift_JIS", "UTF-16BE", "UTF-16LE", "UTF-32BE", "UTF-32LE",
#   "Windows-1251", "BINARY", "IBM437", "CP437", "IBM737", "CP737",
#   "IBM775", "CP775", "CP850", "IBM850", "IBM852", "CP852", "IBM855",
#   "CP855", "IBM857", "CP857", "IBM860", "CP860", "IBM861", "CP861",
#   "IBM862", "CP862", "IBM863", "CP863", "IBM864", "CP864", "IBM865",
#   "CP865", "IBM866", "CP866", "IBM869", "CP869", "Windows-1258",
#   "CP1258", "GB1988", "macCentEuro", "macCroatian", "macCyrillic",
#   "macGreek", "macIceland", "macRoman", "macRomania", "macThai",
#   "macTurkish", "macUkraine", "CP950", "Big5-HKSCS:2008", "CP951",
#   "stateless-ISO-2022-JP", "eucJP", "eucJP-ms", "euc-jp-ms", "CP51932",
#   "eucKR", "eucTW", "GB2312", "EUC-CN", "eucCN", "GB12345", "CP936",
#   "ISO-2022-JP", "ISO2022-JP", "ISO-2022-JP-2", "ISO2022-JP2",
#   "CP50220", "CP50221", "ISO8859-1", "Windows-1252", "CP1252",
#   "ISO8859-2", "Windows-1250", "CP1250", "ISO8859-3", "ISO8859-4",
#   "ISO8859-5", "ISO8859-6", "Windows-1256", "CP1256", "ISO8859-7",
#   "Windows-1253", "CP1253", "ISO8859-8", "Windows-1255", "CP1255",
#   "ISO8859-9", "Windows-1254", "CP1254", "ISO8859-10", "ISO8859-11",
#   "TIS-620", "Windows-874", "CP874", "ISO8859-13", "Windows-1257",
#   "CP1257", "ISO8859-14", "ISO8859-15", "ISO8859-16", "CP878",
#   "Windows-31J", "CP932", "csWindows31J", "SJIS", "PCK", "MacJapanese",
#   "MacJapan", "ASCII", "ANSI_X3.4-1968", "646", "UTF-7", "CP65000",
#   "CP65001", "UTF8-MAC", "UTF-8-MAC", "UTF-8-HFS", "UTF-16", "UTF-32",
#   "UCS-2BE", "UCS-4BE", "UCS-4LE", "CP1251", "UTF8-DoCoMo",
#   "SJIS-DoCoMo", "UTF8-KDDI", "SJIS-KDDI", "ISO-2022-JP-KDDI",
#   "stateless-ISO-2022-JP-KDDI", "UTF8-SoftBank", "SJIS-SoftBank",
#   "locale", "external", "filesystem", "internal"
#   Default value: "UTF-8"
#   This variable is optional
#
# [*debug*]
#   Set this to true to enable debugging on an input.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*format*]
#   The format of input data (plain, json, json_event)
#   Value can be any of: "plain", "json", "json_event", "msgpack_event"
#   Default value: None
#   This variable is optional
#
# [*message_format*]
#   If format is "json", an event sprintf string to build what the display
#   @message should be given (defaults to the raw JSON). sprintf format
#   strings look like %{fieldname} or %{@metadata}.  If format is
#   "json_event", ALL fields except for @type are expected to be present.
#   Not receiving all fields will cause unexpected results.
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*queue*]
#   Name of the SQS Queue name to pull messages from. Note that this is
#   just the name of the queue, not the URL or ARN.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*region*]
#   Value can be any of: "us-east-1", "us-west-1", "us-west-2",
#   "eu-west-1", "ap-southeast-1", "ap-southeast-2", "ap-northeast-1",
#   "sa-east-1", "us-gov-west-1"
#   Default value: "us-east-1"
#   This variable is optional
#
# [*secret_access_key*]
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
# [*threads*]
#   Set this to the number of threads you want this input to spawn. This
#   is the same as declaring the input multiple times
#   Value type is number
#   Default value: 1
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
#   This variable is required
#
# [*use_ssl*]
#   Value type is boolean
#   Default value: true
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
#  Extra information about this input can be found at:
#  http://logstash.net/docs/1.1.12/inputs/sqs
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::input::sqs (
  $queue,
  $type,
  $aws_credentials_file = '',
  $charset              = '',
  $debug                = '',
  $format               = '',
  $message_format       = '',
  $add_field            = '',
  $region               = '',
  $secret_access_key    = '',
  $tags                 = '',
  $threads              = '',
  $access_key_id        = '',
  $use_ssl              = '',
  $instances            = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/input_sqs_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/input/sqs/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/input_sqs_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/input/sqs/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($use_ssl != '') {
    validate_bool($use_ssl)
    $opt_use_ssl = "  use_ssl => ${use_ssl}\n"
  }

  if ($debug != '') {
    validate_bool($debug)
    $opt_debug = "  debug => ${debug}\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if ($threads != '') {
    if ! is_numeric($threads) {
      fail("\"${threads}\" is not a valid threads parameter value")
    } else {
      $opt_threads = "  threads => ${threads}\n"
    }
  }

  if ($charset != '') {
    if ! ($charset in ['ASCII-8BIT', 'UTF-8', 'US-ASCII', 'Big5', 'Big5-HKSCS', 'Big5-UAO', 'CP949', 'Emacs-Mule', 'EUC-JP', 'EUC-KR', 'EUC-TW', 'GB18030', 'GBK', 'ISO-8859-1', 'ISO-8859-2', 'ISO-8859-3', 'ISO-8859-4', 'ISO-8859-5', 'ISO-8859-6', 'ISO-8859-7', 'ISO-8859-8', 'ISO-8859-9', 'ISO-8859-10', 'ISO-8859-11', 'ISO-8859-13', 'ISO-8859-14', 'ISO-8859-15', 'ISO-8859-16', 'KOI8-R', 'KOI8-U', 'Shift_JIS', 'UTF-16BE', 'UTF-16LE', 'UTF-32BE', 'UTF-32LE', 'Windows-1251', 'BINARY', 'IBM437', 'CP437', 'IBM737', 'CP737', 'IBM775', 'CP775', 'CP850', 'IBM850', 'IBM852', 'CP852', 'IBM855', 'CP855', 'IBM857', 'CP857', 'IBM860', 'CP860', 'IBM861', 'CP861', 'IBM862', 'CP862', 'IBM863', 'CP863', 'IBM864', 'CP864', 'IBM865', 'CP865', 'IBM866', 'CP866', 'IBM869', 'CP869', 'Windows-1258', 'CP1258', 'GB1988', 'macCentEuro', 'macCroatian', 'macCyrillic', 'macGreek', 'macIceland', 'macRoman', 'macRomania', 'macThai', 'macTurkish', 'macUkraine', 'CP950', 'Big5-HKSCS:2008', 'CP951', 'stateless-ISO-2022-JP', 'eucJP', 'eucJP-ms', 'euc-jp-ms', 'CP51932', 'eucKR', 'eucTW', 'GB2312', 'EUC-CN', 'eucCN', 'GB12345', 'CP936', 'ISO-2022-JP', 'ISO2022-JP', 'ISO-2022-JP-2', 'ISO2022-JP2', 'CP50220', 'CP50221', 'ISO8859-1', 'Windows-1252', 'CP1252', 'ISO8859-2', 'Windows-1250', 'CP1250', 'ISO8859-3', 'ISO8859-4', 'ISO8859-5', 'ISO8859-6', 'Windows-1256', 'CP1256', 'ISO8859-7', 'Windows-1253', 'CP1253', 'ISO8859-8', 'Windows-1255', 'CP1255', 'ISO8859-9', 'Windows-1254', 'CP1254', 'ISO8859-10', 'ISO8859-11', 'TIS-620', 'Windows-874', 'CP874', 'ISO8859-13', 'Windows-1257', 'CP1257', 'ISO8859-14', 'ISO8859-15', 'ISO8859-16', 'CP878', 'Windows-31J', 'CP932', 'csWindows31J', 'SJIS', 'PCK', 'MacJapanese', 'MacJapan', 'ASCII', 'ANSI_X3.4-1968', '646', 'UTF-7', 'CP65000', 'CP65001', 'UTF8-MAC', 'UTF-8-MAC', 'UTF-8-HFS', 'UTF-16', 'UTF-32', 'UCS-2BE', 'UCS-4BE', 'UCS-4LE', 'CP1251', 'UTF8-DoCoMo', 'SJIS-DoCoMo', 'UTF8-KDDI', 'SJIS-KDDI', 'ISO-2022-JP-KDDI', 'stateless-ISO-2022-JP-KDDI', 'UTF8-SoftBank', 'SJIS-SoftBank', 'locale', 'external', 'filesystem', 'internal']) {
      fail("\"${charset}\" is not a valid charset parameter value")
    } else {
      $opt_charset = "  charset => \"${charset}\"\n"
    }
  }

  if ($format != '') {
    if ! ($format in ['plain', 'json', 'json_event', 'msgpack_event']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if ($region != '') {
    if ! ($region in ['us-east-1', 'us-west-1', 'us-west-2', 'eu-west-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'sa-east-1', 'us-gov-west-1']) {
      fail("\"${region}\" is not a valid region parameter value")
    } else {
      $opt_region = "  region => \"${region}\"\n"
    }
  }

  if ($queue != '') {
    validate_string($queue)
    $opt_queue = "  queue => \"${queue}\"\n"
  }

  if ($secret_access_key != '') {
    validate_string($secret_access_key)
    $opt_secret_access_key = "  secret_access_key => \"${secret_access_key}\"\n"
  }

  if ($message_format != '') {
    validate_string($message_format)
    $opt_message_format = "  message_format => \"${message_format}\"\n"
  }

  if ($aws_credentials_file != '') {
    validate_string($aws_credentials_file)
    $opt_aws_credentials_file = "  aws_credentials_file => \"${aws_credentials_file}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($access_key_id != '') {
    validate_string($access_key_id)
    $opt_access_key_id = "  access_key_id => \"${access_key_id}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "input {\n sqs {\n${opt_access_key_id}${opt_add_field}${opt_aws_credentials_file}${opt_charset}${opt_debug}${opt_format}${opt_message_format}${opt_queue}${opt_region}${opt_secret_access_key}${opt_tags}${opt_threads}${opt_type}${opt_use_ssl} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

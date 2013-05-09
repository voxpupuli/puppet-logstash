# == Define: logstash::output::sqs
#
#   Push events to an Amazon Web Services Simple Queue Service (SQS)
#   queue.  SQS is a simple, scalable queue system that is part of the
#   Amazon Web Services suite of tools.  Although SQS is similar to other
#   queuing systems like AMQP, it uses a custom API and requires that you
#   have an AWS account. See http://aws.amazon.com/sqs/ for more details
#   on how SQS works, what the pricing schedule looks like and how to
#   setup a queue.  To use this plugin, you must:  Have an AWS account
#   Setup an SQS queue Create an identify that has access to publish
#   messages to the queue. The "consumer" identity must have the following
#   permissions on the queue:  sqs:ChangeMessageVisibility
#   sqs:ChangeMessageVisibilityBatch sqs:GetQueueAttributes
#   sqs:GetQueueUrl sqs:ListQueues sqs:SendMessage sqs:SendMessageBatch
#   Typically, you should setup an IAM policy, create a user and apply the
#   IAM policy to the user. A sample policy is as follows:   {
#   "Statement": [      {        "Sid": "Stmt1347986764948",
#   "Action": [          "sqs:ChangeMessageVisibility",
#   "sqs:ChangeMessageVisibilityBatch",          "sqs:DeleteMessage",
#   "sqs:DeleteMessageBatch",          "sqs:GetQueueAttributes",
#   "sqs:GetQueueUrl",          "sqs:ListQueues",
#   "sqs:ReceiveMessage"        ],        "Effect": "Allow",
#   "Resource": [          "arn:aws:sqs:us-east-1:200850199751:Logstash"
#   ]      }    ]  }   See http://aws.amazon.com/iam/ for more details on
#   setting up AWS identities.
#
#
# === Parameters
#
# [*access_key_id*]
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*aws_credentials_file*]
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
# [*queue*]
#   Name of SQS queue to push messages into. Note that this is just the
#   name of the queue, not the URL or ARN.
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
#  Extra information about this output can be found at:
#  http://logstash.net/docs/1.1.12/outputs/sqs
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::sqs (
  $queue,
  $region               = '',
  $aws_credentials_file = '',
  $exclude_tags         = '',
  $fields               = '',
  $access_key_id        = '',
  $secret_access_key    = '',
  $tags                 = '',
  $type                 = '',
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
    $conffiles    = suffix($confdirstart, "/config/output_sqs_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/sqs/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_sqs_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/sqs/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($fields != '') {
    validate_array($fields)
    $arr_fields = join($fields, '\', \'')
    $opt_fields = "  fields => ['${arr_fields}']\n"
  }

  if ($exclude_tags != '') {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if ($use_ssl != '') {
    validate_bool($use_ssl)
    $opt_use_ssl = "  use_ssl => ${use_ssl}\n"
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
    content => "output {\n sqs {\n${opt_access_key_id}${opt_aws_credentials_file}${opt_exclude_tags}${opt_fields}${opt_queue}${opt_region}${opt_secret_access_key}${opt_tags}${opt_type}${opt_use_ssl} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

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
# [*access_key*]
#   AWS access key. Must have the appropriate permissions.
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
# [*queue*]
#   Name of SQS queue to push messages into. Note that this is just the
#   name of the queue, not the URL or ARN.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*secret_key*]
#   AWS secret key. Must have the appropriate permissions.
#   Value type is string
#   Default value: None
#   This variable is required
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
#  http://logstash.net/docs/1.1.9/outputs/sqs
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::sqs (
  $access_key,
  $secret_key,
  $queue,
  $fields       = '',
  $exclude_tags = '',
  $tags         = '',
  $type         = ''
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

  if $queue {
    validate_string($queue)
    $opt_queue = "  queue => \"${queue}\"\n"
  }

  if $secret_key {
    validate_string($secret_key)
    $opt_secret_key = "  secret_key => \"${secret_key}\"\n"
  }

  if $access_key {
    validate_string($access_key)
    $opt_access_key = "  access_key => \"${access_key}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_sqs_${name}":
    ensure  => present,
    content => "output {\n sqs {\n${opt_access_key}${opt_exclude_tags}${opt_fields}${opt_queue}${opt_secret_key}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

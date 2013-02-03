# == Define: logstash::output::circonus
#
#
#
# === Parameters
#
# [*annotation*]
#   Annotations Registers an annotation with Circonus The only required
#   field is title and description. start and stop will be set to
#   event.unix_timestamp You can add any other optional annotation values
#   as well. All values will be passed through event.sprintf  Example:
#   ["title":"Logstash event", "description":"Logstash event for
#   %{@sourcehost}"] or   ["title":"Logstash event",
#   "description":"Logstash event for %{@sourcehost}", "parent_id", "1"]
#   Value type is hash
#   Default value: {}
#   This variable is required
#
# [*api_token*]
#   This output lets you send annotations to Circonus based on Logstash
#   events  Your Circonus API Token
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*app_name*]
#   Your Circonus App name This will be passed through event.sprintf so
#   variables are allowed here:  Example:  app_name =&gt; "%{myappname}"
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
#  http://logstash.net/docs/1.1.9/outputs/circonus
#
#  Need help? http://logstash.net/docs/1.1.9/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::circonus (
  $annotation,
  $api_token,
  $app_name,
  $exclude_tags = '',
  $fields       = '',
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

  if $annotation {
    validate_hash($annotation)
    $arr_annotation = inline_template('<%= annotation.to_a.flatten.inspect %>')
    $opt_annotation = "  annotation => ${arr_annotation}\n"
  }

  if $app_name {
    validate_string($app_name)
    $opt_app_name = "  app_name => \"${app_name}\"\n"
  }

  if $api_token {
    validate_string($api_token)
    $opt_api_token = "  api_token => \"${api_token}\"\n"
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  #### Write config file

  file { "${logstash::params::configdir}/output_circonus_${name}":
    ensure  => present,
    content => "output {\n circonus {\n${opt_annotation}${opt_api_token}${opt_app_name}${opt_exclude_tags}${opt_fields}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Class['logstash::service'],
    require => Class['logstash::package', 'logstash::config']
  }
}

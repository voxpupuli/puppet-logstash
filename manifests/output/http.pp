# == Define: logstash::output::http
#
#
#
# === Parameters
#
# [*content_type*]
#   Content type  If not specified, this defaults to the following:  if
#   format is "json", "application/json" if format is "form",
#   "application/x-www-form-urlencoded"
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
#   Set the format of the http body.  If form, then the body will be the
#   mapping (or whole event) converted into a query parameter string
#   (foo=bar&amp;baz=fizz...)  If message, then the body will be the
#   result of formatting the event according to message  Otherwise, the
#   event is sent as json.
#   Value can be any of: "json", "form", "message"
#   Default value: "json"
#   This variable is optional
#
# [*headers*]
#   Custom headers to use format is `headers =&gt; ["X-My-Header",
#   "%{@source_host}"]
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*http_method*]
#   What verb to use only put and post are supported for now
#   Value can be any of: "put", "post"
#   Default value: None
#   This variable is required
#
# [*mapping*]
#   This lets you choose the structure and parts of the event that are
#   sent.  For example:     mapping =&gt; ["foo", "%{@source_host}",
#   "bar", "%{@type}"]
#   Value type is hash
#   Default value: None
#   This variable is optional
#
# [*message*]
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
# [*url*]
#   This output lets you PUT or POST events to a generic HTTP(S) endpoint
#   Additionally, you are given the option to customize the headers sent
#   as well as basic customization of the event json itself. URL to use
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*verify_ssl*]
#   validate SSL?
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
#  http://logstash.net/docs/1.1.12/outputs/http
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::http (
  $http_method,
  $url,
  $mapping      = '',
  $format       = '',
  $headers      = '',
  $content_type = '',
  $fields       = '',
  $message      = '',
  $tags         = '',
  $type         = '',
  $exclude_tags = '',
  $verify_ssl   = '',
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_http_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/http/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_http_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/http/${name}"

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

  if ($verify_ssl != '') {
    validate_bool($verify_ssl)
    $opt_verify_ssl = "  verify_ssl => ${verify_ssl}\n"
  }

  if ($headers != '') {
    validate_hash($headers)
    $var_headers = $headers
    $arr_headers = inline_template('<%= "["+var_headers.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_headers = "  headers => ${arr_headers}\n"
  }

  if ($mapping != '') {
    validate_hash($mapping)
    $var_mapping = $mapping
    $arr_mapping = inline_template('<%= "["+var_mapping.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_mapping = "  mapping => ${arr_mapping}\n"
  }

  if ($http_method != '') {
    if ! ($http_method in ['put', 'post']) {
      fail("\"${http_method}\" is not a valid http_method parameter value")
    } else {
      $opt_http_method = "  http_method => \"${http_method}\"\n"
    }
  }

  if ($format != '') {
    if ! ($format in ['json', 'form', 'message']) {
      fail("\"${format}\" is not a valid format parameter value")
    } else {
      $opt_format = "  format => \"${format}\"\n"
    }
  }

  if ($url != '') {
    validate_string($url)
    $opt_url = "  url => \"${url}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($message != '') {
    validate_string($message)
    $opt_message = "  message => \"${message}\"\n"
  }

  if ($content_type != '') {
    validate_string($content_type)
    $opt_content_type = "  content_type => \"${content_type}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n http {\n${opt_content_type}${opt_exclude_tags}${opt_fields}${opt_format}${opt_headers}${opt_http_method}${opt_mapping}${opt_message}${opt_tags}${opt_type}${opt_url}${opt_verify_ssl} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

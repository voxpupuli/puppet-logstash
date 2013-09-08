# == Define: logstash::output::email
#
#
#
# === Parameters
#
# [*attachments*]
#   attachments - has of name of file and file location
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*body*]
#   body for email - just plain text
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*cc*]
#   cc - send to others See to field for accepted value description
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*contenttype*]
#   contenttype : for multipart messages, set the content type and/or
#   charset of the html part
#   Value type is string
#   Default value: "text/html; charset=UTF-8"
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
# [*from*]
#   The From setting for email - fully qualified email address for the
#   From:
#   Value type is string
#   Default value: "logstash.alert@nowhere.com"
#   This variable is optional
#
# [*htmlbody*]
#   body for email - can contain html markup
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*match*]
#   The registered fields that we want to monitor A hash of matches of
#   field =&gt; value Takes the form of:     { "match name",
#   "field.in.event,value.expected, ,
#   operand(and/or),field.in.event,value.expected, , or...",    "match
#   name", "..." }  The match name can be referenced using the
#   %{matchName} field.
#   Value type is hash
#   Default value: None
#   This variable is required
#
# [*options*]
#   the options to use: smtp: address, port, enablestarttlsauto,
#   user_name, password, authentication(bool), domain sendmail: location,
#   arguments If you do not specify anything, you will get the following
#   equivalent code set in every new mail object:    Mail.defaults do
#   delivery_method :smtp, { :address              =&gt; "localhost",
#   :port                 =&gt; 25,                          :domain
#   =&gt; 'localhost.localdomain',                          :user_name
#   =&gt; nil,                          :password             =&gt; nil,
#   :authentication       =&gt; nil,(plain, login and cram_md5)
#   :enable_starttls_auto =&gt; true  }  retriever_method :pop3, {
#   :address             =&gt; "localhost",
#   :port                =&gt; 995,                           :user_name
#   =&gt; nil,                           :password            =&gt; nil,
#   :enable_ssl          =&gt; true }     end    Mail.deliverymethod.new
#   #=&gt; Mail::SMTP instance   Mail.retrievermethod.new #=&gt;
#   Mail::POP3 instance  Each mail object inherits the default set in
#   Mail.delivery_method, however, on a per email basis, you can override
#   the method:    mail.delivery_method :sendmail  Or you can override the
#   method and pass in settings:    mail.delivery_method :sendmail, {
#   :address =&gt; 'some.host' }  You can also just modify the settings:
#   mail.delivery_settings = { :address =&gt; 'some.host' }  The passed in
#   hash is just merged against the defaults with +merge!+ and the result
#   assigned the mail object.  So the above example will change only the
#   :address value of the global smtp_settings to be 'some.host', keeping
#   all other values
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*subject*]
#   subject for email
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*tags*]
#   Only handle events with all of these tags.  Note that if you specify a
#   type, the event must also match that type. Optional.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*to*]
#   The To address setting - fully qualified email address to send to This
#   field also accept a comma separated list of emails like "me@host.com,
#   you@host.com" You can also use dynamic field from the event with the
#   %{fieldname} syntax
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*type*]
#   The type to act on. If a type is given, then this output will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*via*]
#   how to send email: either smtp or sendmail - default to 'smtp'
#   Value type is string
#   Default value: "smtp"
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
#  http://logstash.net/docs/1.1.12/outputs/email
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::output::email (
  $match,
  $to,
  $attachments  = '',
  $contenttype  = '',
  $exclude_tags = '',
  $fields       = '',
  $from         = '',
  $htmlbody     = '',
  $cc           = '',
  $options      = '',
  $subject      = '',
  $tags         = '',
  $body         = '',
  $type         = '',
  $via          = '',
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/output_email_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/output/email/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/output_email_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/output/email/${name}"

  }

  #### Validate parameters
  if ($attachments != '') {
    validate_array($attachments)
    $arr_attachments = join($attachments, '\', \'')
    $opt_attachments = "  attachments => ['${arr_attachments}']\n"
  }

  if ($tags != '') {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

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


  validate_array($instances)

  if ($match != '') {
    validate_hash($match)
    $var_match = $match
    $arr_match = inline_template('<%= "["+var_match.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_match = "  match => ${arr_match}\n"
  }

  if ($options != '') {
    validate_hash($options)
    $var_options = $options
    $arr_options = inline_template('<%= "["+var_options.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_options = "  options => ${arr_options}\n"
  }

  if ($subject != '') {
    validate_string($subject)
    $opt_subject = "  subject => \"${subject}\"\n"
  }

  if ($cc != '') {
    validate_string($cc)
    $opt_cc = "  cc => \"${cc}\"\n"
  }

  if ($from != '') {
    validate_string($from)
    $opt_from = "  from => \"${from}\"\n"
  }

  if ($htmlbody != '') {
    validate_string($htmlbody)
    $opt_htmlbody = "  htmlbody => \"${htmlbody}\"\n"
  }

  if ($body != '') {
    validate_string($body)
    $opt_body = "  body => \"${body}\"\n"
  }

  if ($to != '') {
    validate_string($to)
    $opt_to = "  to => \"${to}\"\n"
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($via != '') {
    validate_string($via)
    $opt_via = "  via => \"${via}\"\n"
  }

  if ($contenttype != '') {
    validate_string($contenttype)
    $opt_contenttype = "  contenttype => \"${contenttype}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "output {\n email {\n${opt_attachments}${opt_body}${opt_cc}${opt_contenttype}${opt_exclude_tags}${opt_fields}${opt_from}${opt_htmlbody}${opt_match}${opt_options}${opt_subject}${opt_tags}${opt_to}${opt_type}${opt_via} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

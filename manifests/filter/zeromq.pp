# == Define: logstash::filter::zeromq
#
#   ZeroMQ filter. This is the best way to send an event externally for
#   filtering It works much like an exec filter would by sending the event
#   "offsite" for processing and waiting for a response  The protocol here
#   is:   * REQ sent with JSON-serialized logstash event   * REP read
#   expected to be the full JSON 'filtered' event   * - if reply read is
#   an empty string, it will cancel the event.  Note that this is a
#   limited subset of the zeromq functionality in inputs and outputs. The
#   only topology that makes sense here is: REQ/REP.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   zeromq {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the zeromq plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   zeromq {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*address*]
#   0mq socket address to connect or bind Please note that inproc:// will
#   not work with logstash as we use a context per thread By default,
#   filters connect
#   Value type is string
#   Default value: "tcp://127.0.0.1:2121"
#   This variable is optional
#
# [*exclude_tags*]
#   Only handle events without any of these tags. Note this check is
#   additional to type and tags.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*field*]
#   The field to send off-site for processing If this is unset, the whole
#   event will be sent TODO (lusis) Allow filtering multiple fields
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*mode*]
#   0mq mode server mode binds/listens client mode connects
#   Value can be any of: "server", "client"
#   Default value: "client"
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   zeromq {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*sockopt*]
#   0mq socket options This exposes zmq_setsockopt for advanced tuning see
#   http://api.zeromq.org/2-1:zmq-setsockopt for details  This is where
#   you would set values like: ZMQ::HWM - high water mark ZMQ::IDENTITY -
#   named queues ZMQ::SWAP_SIZE - space for disk overflow ZMQ::SUBSCRIBE -
#   topic filters for pubsub  example: sockopt =&gt; ["ZMQ::HWM", 50,
#   "ZMQ::IDENTITY", "mynamedqueue"]
#   Value type is hash
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
#   The type to act on. If a type is given, then this filter will only act
#   on messages with the same type. See any input plugin's "type"
#   attribute for more. Optional.
#   Value type is string
#   Default value: ""
#   This variable is optional
#
# [*order*]
#   The order variable decides in which sequence the filters are loaded.
#   Value type is number
#   Default value: 10
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
#  Extra information about this filter can be found at:
#  http://logstash.net/docs/1.1.12/filters/zeromq
#
#  Need help? http://logstash.net/docs/1.1.12/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::zeromq (
  $add_field    = '',
  $add_tag      = '',
  $address      = '',
  $exclude_tags = '',
  $field        = '',
  $mode         = '',
  $remove_tag   = '',
  $sockopt      = '',
  $tags         = '',
  $type         = '',
  $order        = 10,
  $instances    = [ 'agent' ]
) {

  require logstash::params

  File {
    owner => $logstash::logstash_user,
    group => $logstash::logstash_group
  }

  if $logstash::multi_instance == true {

    $confdirstart = prefix($instances, "${logstash::configdir}/")
    $conffiles    = suffix($confdirstart, "/config/filter_${order}_zeromq_${name}")
    $services     = prefix($instances, 'logstash-')
    $filesdir     = "${logstash::configdir}/files/filter/zeromq/${name}"

  } else {

    $conffiles = "${logstash::configdir}/conf.d/filter_${order}_zeromq_${name}"
    $services  = 'logstash'
    $filesdir  = "${logstash::configdir}/files/filter/zeromq/${name}"

  }

  #### Validate parameters

  validate_array($instances)

  if ($add_tag != '') {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
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

  if ($remove_tag != '') {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if ($add_field != '') {
    validate_hash($add_field)
    $var_add_field = $add_field
    $arr_add_field = inline_template('<%= "["+var_add_field.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if ($sockopt != '') {
    validate_hash($sockopt)
    $var_sockopt = $sockopt
    $arr_sockopt = inline_template('<%= "["+var_sockopt.sort.collect { |k,v| "\"#{k}\", \"#{v}\"" }.join(", ")+"]" %>')
    $opt_sockopt = "  sockopt => ${arr_sockopt}\n"
  }

  if ($order != '') {
    if ! is_numeric($order) {
      fail("\"${order}\" is not a valid order parameter value")
    }
  }

  if ($mode != '') {
    if ! ($mode in ['server', 'client']) {
      fail("\"${mode}\" is not a valid mode parameter value")
    } else {
      $opt_mode = "  mode => \"${mode}\"\n"
    }
  }

  if ($type != '') {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if ($field != '') {
    validate_string($field)
    $opt_field = "  field => \"${field}\"\n"
  }

  if ($address != '') {
    validate_string($address)
    $opt_address = "  address => \"${address}\"\n"
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n zeromq {\n${opt_add_field}${opt_add_tag}${opt_address}${opt_exclude_tags}${opt_field}${opt_mode}${opt_remove_tag}${opt_sockopt}${opt_tags}${opt_type} }\n}\n",
    mode    => '0440',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

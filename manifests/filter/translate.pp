# == Define: logstash::filter::translate
#
#   Originally written to translate HTTP response codes but turned into a
#   general translation tool which uses configured has or/and .yaml files
#   as a dictionary. response codes in default dictionary were scraped
#   from 'gem install cheat; cheat status_codes'  Alternatively for simple
#   string search and replacements for just a few values use the gsub
#   function of the mutate filter.
#
#
# === Parameters
#
# [*add_field*]
#   If this filter is successful, add any arbitrary fields to this event.
#   Example:  filter {   translate {     add_field =&gt; [ "sample", "Hello
#   world, from %{@source}" ]   } }    On success, the translate plugin
#   will then add field 'sample' with the  value above and the %{@source}
#   piece replaced with that value from the  event.
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*add_tag*]
#   If this filter is successful, add arbitrary tags to the event. Tags
#   can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   translate {     add_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would add a tag "foo_hello"
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*destination*]
#   The destination field you wish to populate with the translation code.
#   default is "translation". Set to the same value as source if you want
#   to do a substitution, in this case filter will allways succeed.
#   Value type is string
#   Default value: "translation"
#   This variable is optional
#
# [*dictionary*]
#   Dictionary to use for translation. Example:  filter {   translate {
#   dictionary =&gt; [ "100", "Continue",                     "101",
#   "Switching Protocols",                     "200", "OK",
#   "201", "Created",                     "202", "Accepted" ]   } }
#   Value type is hash
#   Default value: {}
#   This variable is optional
#
# [*dictionary_path*]
#   name with full path of external dictionary file.   format of the table
#   should be a YAML file which will be merged with the @dictionary. make
#   sure you encase any integer based keys in quotes.
#   Value type is path
#   Default value: None
#   This variable is optional
#
# [*exact*]
#   set to false if you want to match multiple terms a large dictionary
#   could get expensive if set to false.
#   Value type is boolean
#   Default value: true
#   This variable is optional
#
# [*exclude_tags*]
#   Only handle events without any of these tags. Note this check is
#   additional to type and tags.
#   Value type is array
#   Default value: []
#   This variable is optional
#
# [*fallback*]
#   Incase no translation was made add default translation string
#   Value type is string
#   Default value: None
#   This variable is optional
#
# [*field*]
#   The field containing a response code If this field is an array, only
#   the first value will be used.
#   Value type is string
#   Default value: None
#   This variable is required
#
# [*override*]
#   In case dstination field already exists should we skip
#   translation(default) or override it with new translation
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*regex*]
#   treat dictionary keys as regular expressions to match against, used
#   only then @exact enabled.
#   Value type is boolean
#   Default value: false
#   This variable is optional
#
# [*remove_tag*]
#   If this filter is successful, remove arbitrary tags from the event.
#   Tags can be dynamic and include parts of the event using the %{field}
#   syntax. Example:  filter {   translate {     remove_tag =&gt; [
#   "foo_%{somefield}" ]   } }   If the event has field "somefield" ==
#   "hello" this filter, on success, would remove the tag "foo_hello" if
#   it is present
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
#
# === Examples
#
#
#
#
# === Extra information
#
#  This define is created based on LogStash version 1.1.10
#  Extra information about this filter can be found at:
#  http://logstash.net/docs/1.1.10/filters/translate
#
#  Need help? http://logstash.net/docs/1.1.10/learn
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard@ispavailability.com>
#
define logstash::filter::translate (
  $field,
  $add_field       = '',
  $destination     = '',
  $dictionary      = '',
  $dictionary_path = '',
  $exact           = '',
  $exclude_tags    = '',
  $fallback        = '',
  $add_tag         = '',
  $override        = '',
  $regex           = '',
  $remove_tag      = '',
  $tags            = '',
  $type            = '',
  $order           = 10,
  $instances       = [ 'agent' ]
) {

  require logstash::params

  $confdirstart = prefix($instances, "${logstash::configdir}/")
  $conffiles = suffix($confdirstart, "/config/filter_${order}_translate_${name}")
  $services = prefix($instances, 'logstash-')
  $filesdir = "${logstash::configdir}/files/filter/translate/${name}"

  #### Validate parameters

  validate_array($instances)

  if $add_tag {
    validate_array($add_tag)
    $arr_add_tag = join($add_tag, '\', \'')
    $opt_add_tag = "  add_tag => ['${arr_add_tag}']\n"
  }

  if $tags {
    validate_array($tags)
    $arr_tags = join($tags, '\', \'')
    $opt_tags = "  tags => ['${arr_tags}']\n"
  }

  if $exclude_tags {
    validate_array($exclude_tags)
    $arr_exclude_tags = join($exclude_tags, '\', \'')
    $opt_exclude_tags = "  exclude_tags => ['${arr_exclude_tags}']\n"
  }

  if $remove_tag {
    validate_array($remove_tag)
    $arr_remove_tag = join($remove_tag, '\', \'')
    $opt_remove_tag = "  remove_tag => ['${arr_remove_tag}']\n"
  }

  if $exact {
    validate_bool($exact)
    $opt_exact = "  exact => ${exact}\n"
  }

  if $override {
    validate_bool($override)
    $opt_override = "  override => ${override}\n"
  }

  if $regex {
    validate_bool($regex)
    $opt_regex = "  regex => ${regex}\n"
  }

  if $dictionary {
    validate_hash($dictionary)
    $arr_dictionary = inline_template('<%= dictionary.to_a.flatten.inspect %>')
    $opt_dictionary = "  dictionary => ${arr_dictionary}\n"
  }

  if $add_field {
    validate_hash($add_field)
    $arr_add_field = inline_template('<%= add_field.to_a.flatten.inspect %>')
    $opt_add_field = "  add_field => ${arr_add_field}\n"
  }

  if $order {
    if ! is_numeric($order) {
      fail("\"${order}\" is not a valid order parameter value")
    }
  }

  if $dictionary_path {
    if $dictionary_path =~ /^puppet\:\/\// {

      validate_re($dictionary_path, '\Apuppet:\/\/')

      $filenameArray = split($dictionary_path, '/')
      $basefilename = $filenameArray[-1]

      $opt_dictionary_path = "  dictionary_path => \"${filesdir}/${basefilename}\"\n"

      file { "${filesdir}/${basefilename}":
        source  => $dictionary_path,
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        require => File[$filesdir]
      }
    } else {
      $opt_dictionary_path = "  dictionary_path => \"${dictionary_path}\"\n"
    }
  }

  if $type {
    validate_string($type)
    $opt_type = "  type => \"${type}\"\n"
  }

  if $destination {
    validate_string($destination)
    $opt_destination = "  destination => \"${destination}\"\n"
  }

  if $fallback {
    validate_string($fallback)
    $opt_fallback = "  fallback => \"${fallback}\"\n"
  }

  if $field {
    validate_string($field)
    $opt_field = "  field => \"${field}\"\n"
  }


  #### Create the directory where we place the files
  exec { "create_files_dir_filter_translate_${name}":
    cwd     => '/',
    path    => ['/usr/bin', '/bin'],
    command => "mkdir -p ${filesdir}",
    creates => $filesdir
  }

  #### Manage the files directory
  file { $filesdir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    purge   => true,
    recurse => true,
    require => Exec["create_files_dir_filter_translate_${name}"],
    notify  => Service[$services]
  }

  #### Write config file

  file { $conffiles:
    ensure  => present,
    content => "filter {\n translate {\n${opt_add_field}${opt_add_tag}${opt_destination}${opt_dictionary}${opt_dictionary_path}${opt_exact}${opt_exclude_tags}${opt_fallback}${opt_field}${opt_override}${opt_regex}${opt_remove_tag}${opt_tags}${opt_type} }\n}\n",
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    notify  => Service[$services],
    require => Class['logstash::package', 'logstash::config']
  }
}

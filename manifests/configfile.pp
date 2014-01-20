# == define: logstash::configfile
#
# This define is to manage the config files for Logstah
#
# === Parameters
#
# [*file*]
#  Supply a template to be used for the config
#
# [*order*]
#  The order number controls in which sequence the config file fragments are concatenated
#
# === Examples
#
#     logstash::configfile { 'apache':
#       file  => template("${module_name}/path/to/apache.conf.erb"),
#       order => 10
#     }
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
define logstash::configfile(
  $file,
  $order = 10
) {

  @@file_fragment { $name:
    tag     => "LS_CONFIG_${::fqdn}",
    content => $file,
    order   => $order,
  }

}

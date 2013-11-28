# == Define: logstash::condition::if
#
#
#
# === Parameters
#
#
#
# === Examples
#
#
#
# === Authors
#
# * Richard Pijnenburg <mailto:richard.pijnenburg@elasticsearch.com>
#
define logstash::condition::if(
  $expression,
  $children,
  $require = undef
) {

  require logstash

  logstash_condition { $name:
    tag        => "LS_CONDITION_${::fqdn}",
    expression => $expression,
    $children  => $children,
    $require   => $require
  }


}

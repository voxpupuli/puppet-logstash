class logstash::params {
  case $::osfamily {
    'Archlinux': {
      $manage_repo = false
    }
    default: {
      $manage_repo = true
    }
  }
}

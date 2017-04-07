class logstash::params {
  case $facts['os']['family'] {
    'Archlinux': {
      $manage_repo = false
    }
    default: {
      $manage_repo = true
    }
  }
}

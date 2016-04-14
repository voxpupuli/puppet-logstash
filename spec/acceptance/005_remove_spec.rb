require 'spec_helper_acceptance'

case fact('osfamily')
when 'RedHat'
  package_name = 'logstash'
  service_name = 'logstash'
when 'Debian'
  package_name = 'logstash'
  service_name = 'logstash'
when 'Suse'
  package_name = 'logstash'
  service_name = 'logstash'
end

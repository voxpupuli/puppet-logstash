class { 'logstash':
  manage_repo  => true,
  java_install => true,
  # Running the service _seems_ to have negative effects on some tests,
  # particularly the plugin tests, which have a tendency to hang if the
  # service is running.
  status       => 'disabled',
}

logstash::configfile { 'logstash':
  content => '
    input {
      file {
        path => "/tmp/logstash_input_file.txt"
      }
    }

    output {
      file {
        path => "/tmp/logstash_output_file.txt"
        flush_interval => 0
      }
    }
  '
}

require 'spec_helper_acceptance'

describe 'define logstash::configfile' do
  context 'with explicit content' do
    logstash_config = 'input { heartbeat {} }'

    manifest = <<-END
    logstash::configfile { 'heartbeat-input':
      content => '#{logstash_config}'
    }
    END

    before(:context) do
      apply_manifest(manifest, catch_failures: true)
    end

    it 'creates a file with the given content' do
      result = shell('cat /etc/logstash/conf.d/heartbeat-input.conf').stdout
      expect(result).to eq(logstash_config)
    end
  end

  context 'with a puppet:// url as source parameter' do
    manifest = <<-END
    logstash::configfile { 'null-output':
      source => 'puppet:///modules/logstash/null-output.conf'
    }
    END

    before(:context) do
      apply_manifest(manifest, catch_failures: true)
    end

    it 'places the config file' do
      result = shell('cat /etc/logstash/conf.d/null-output.conf').stdout
      expect(result).to include('Test output configuration with null output.')
    end
  end
end

# coding: utf-8
require 'spec_helper_acceptance'

describe 'class plugin' do
  def ensure_plugin(present_absent, plugin, extra_args = nil)
    manifest = <<-END
      logstash::plugin { '#{plugin}':
        ensure => #{present_absent},
        #{extra_args if extra_args}
      }
      END
    apply_manifest(manifest, catch_failures: true)
  end

  def installed_plugins
    shell("/opt/logstash/bin/plugin list").stdout
  end

  def remove(plugin)
    shell("/opt/logstash/bin/plugin uninstall #{plugin} || true")
  end

  context 'with logstash installed' do
    before(:context) do
      install_logstash
    end

    context 'when output-csv is not installed' do
      before(:each) do
        remove('logstash-output-csv')
      end

      it 'will not remove it again' do
        log = ensure_plugin('absent', 'logstash-output-csv').stdout
        expect(log).to_not contain('remove-logstash-output-csv')
      end

      it 'can install it from rubygems' do
        ensure_plugin('present', 'logstash-output-csv')
        expect(installed_plugins).to contain('logstash-output-csv')
      end

      # it 'can install the plugin from a local gem' do
      #   pending
      #   ensure_plugin('present', "source => '/tmp/logstash-output-localtest.gem'")
      #   expect(installed_plugins).to contain('logstash-output-localtest')
      # end
    end

    context 'when input-file is installed' do
      before(:each) { expect(installed_plugins).to contain('logstash-input-file') }

      it 'will not install it again' do
        log = ensure_plugin('present', 'logstash-input-file').stdout
        expect(log).to_not contain('install-logstash-input-file')
      end

      it 'can remove it' do
        ensure_plugin('absent', 'logstash-input-file')
        expect(installed_plugins).not_to contain('logstash-input-file')
      end
    end
  end
end

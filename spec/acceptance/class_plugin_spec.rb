# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'class plugin' do
  before(:all) do
    remove_logstash
    install_logstash('status => "disabled", restart_on_change => false')
  end

  def ensure_plugin(present_absent, plugin, extra_args = nil)
    manifest = <<-END
      class { 'logstash':
        status            => 'disabled',
        restart_on_change => false,
      }
      ->
      logstash::plugin { '#{plugin}':
        ensure => #{present_absent},
        #{extra_args}
      }
    END
    apply_manifest(manifest, catch_failures: true)
  end

  def installed_plugins
    shell('/usr/share/logstash/bin/logstash-plugin list').stdout
  end

  def remove(plugin)
    shell("/usr/share/logstash/bin/logstash-plugin remove #{plugin} || true")
  end

  context 'when a plugin is not installed' do
    before do
      remove('logstash-input-sqs')
    end

    it 'will not remove it again' do
      log = ensure_plugin('absent', 'logstash-input-sqs').stdout
      expect(log).not_to contain('remove-logstash-input-sqs')
    end

    it 'can install it from rubygems' do
      ensure_plugin('present', 'logstash-input-sqs')
      expect(installed_plugins).to contain('logstash-input-sqs')
    end
  end

  context 'when a plugin is installed' do
    it 'will contain the required plugin' do
      expect(installed_plugins).to contain('logstash-input-file')
    end

    it 'will not install it again' do
      log = ensure_plugin('present', 'logstash-input-file').stdout
      expect(log).not_to contain('install-logstash-input-file')
    end

    it 'can remove it' do
      ensure_plugin('absent', 'logstash-input-file')
      expect(installed_plugins).not_to contain('logstash-input-file')
    end
  end

  if Gem::Version.new(LS_VERSION) >= Gem::Version.new('5.2.0')
    it 'can install x-pack from an https url' do
      skip('The latest x-pack release is 6.2.4 released April 17, 2018 ...')
      plugin = 'x-pack'
      source = "https://artifacts.elastic.co/downloads/packs/x-pack/x-pack-#{LS_VERSION}.zip"
      ensure_plugin('present', plugin, "source => '#{source}'")
      expect(installed_plugins).to contain(plugin)
    end
  end

  it 'can install a plugin from a "puppet://" url' do
    skip('There is no plugins embedded in the module ...')
    plugin = 'logstash-output-cowthink'
    source = "puppet:///modules/logstash/#{plugin}-5.0.0.gem"
    ensure_plugin('present', plugin, "source => '#{source}'")
    expect(installed_plugins).to contain(plugin)
  end

  it 'can install a plugin from a local gem' do
    skip('No download means no local plugin available ...')
    plugin = 'logstash-output-cowsay'
    source = "/tmp/#{plugin}-5.0.0.gem"
    ensure_plugin('present', plugin, "source => '#{source}'")
    expect(installed_plugins).to contain(plugin)
  end

  it 'can install a plugin from an offline zip' do
    skip('There is no plugins embedded in the module ...')
    plugin = 'logstash-output-cowsay'
    source = "puppet:///modules/logstash/#{plugin}-5.0.0.zip"
    ensure_plugin('present', plugin, "source => '#{source}'")
    expect(installed_plugins).to contain(plugin)
  end
end

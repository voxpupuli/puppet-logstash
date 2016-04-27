require 'spec_helper_acceptance'

describe 'class plugin' do
  context 'with logstash installed' do
    install_logstash
    exe = '/opt/logstash/bin/plugin'

    context 'when a plugin is not installed' do
      plugin = 'logstash-output-stdout'
      if shell("#{exe} list").stdout.include?(plugin)
        shell("#{exe} uninstall #{plugin}")
      end

      it 'can install the plugin from rubygems' do
        apply_manifest("logstash::plugin { '#{plugin}': }")
        expect(shell("#{exe} list").stdout).to contain(plugin)
      end
    end
  end
end

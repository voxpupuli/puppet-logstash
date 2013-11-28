Puppet::Type.newtype(:logstash_config_fragment) do

  @doc = ""

  newparam(:name, :namevar => true) do
    desc "Unique name"
  end

  newparam(:plugin_type) do
    desc "Plugin type"
  end

  newparam(:content) do
    desc "content"
  end

  newparam(:require) do
    desc "defines which resources comes in front of this one"
  end

  newparam(:tag) do
    desc "Tag"
  end

  validate do
    # think up some validation
  end

end


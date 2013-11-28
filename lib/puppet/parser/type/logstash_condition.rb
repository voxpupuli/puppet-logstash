Puppet::Type.newtype(:logstash_condition) do


  @doc = ""

  newparam(:name, :namevar => true) do
    desc "Unique name"
  end

  newparam(:condition) do
    desc "Condition ( if, elsif, else )"
  end

  newparam(:expression) do
    desc "Expression"
  end

  newparam(:children) do
    desc "Children items"
  end

  newparam(:require) do
    desc "Require which resource to be in front of this one"
  end

  newparam(:tag) do
    desc "Tag"
  end

  validate do
    # think up some validation
  end

end


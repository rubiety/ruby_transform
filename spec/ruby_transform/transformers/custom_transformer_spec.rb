require 'spec_helper'

transformer = RubyTransform::Transformers::Custom.new do |expression|
  if sexp?(expression) && expression.kind == :str
    s(:str, expression.body[0].reverse)
  else
    super
  end
end

describe(transformer) do
  
  describe "some strings" do
    subject { %{
      s = "one"
      t = "two"
    }}
    
    it { should transform_to("reverse", %{
      s = "eno"
      t = "owt"
    }) }
  end
  
end

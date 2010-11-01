require "spec_helper"

describe RubyTransform::Registry do
  before do
    RubyTransform::Registry.configure do
      register :blocks_to_symbols, RubyTransform::Transformers::BlockMethodToProcifier.new
      register :eachify, RubyTransform::Transformers::Eachifier.new
      register :tapify, RubyTransform::Transformers::Tapifier.new
      
      register :underscore_names, RubyTransform::Transformers::SymbolNames.new {|name| name.underscore }
      
      register :composite_with_objects, [
        RubyTransform::Transformers::BlockMethodToProcifier.new,
        RubyTransform::Transformers::Eachifier.new,
        RubyTransform::Transformers::Tapifier.new
      ]
      
      register :composite_with_symbols, [
        :blocks_to_symbols,
        :eachify,
        :tapify
      ]
    end
  end
  
  it "should have registered blocks to symbols" do
    RubyTransform::Registry["blocks_to_symbols"].should be_a(RubyTransform::Transformers::BlockMethodToProcifier)
  end
  
  it "should have registered eachify" do
    RubyTransform::Registry["eachify"].should be_a(RubyTransform::Transformers::Eachifier)
  end
  
  it "should have registered tapify" do
    RubyTransform::Registry["tapify"].should be_a(RubyTransform::Transformers::Tapifier)
  end
  
  it "should have registered underscore_names" do
    RubyTransform::Registry["underscore_names"].should be_a(RubyTransform::Transformers::SymbolNames)
  end
  
  it "should have registered composite_with_objects" do
    RubyTransform::Registry["composite_with_objects"].should be_a(RubyTransform::Transformers::Composite)
  end
  
  it "should have registered composite_with_symbols" do
    RubyTransform::Registry["composite_with_symbols"].should be_a(RubyTransform::Transformers::Composite)
  end
end

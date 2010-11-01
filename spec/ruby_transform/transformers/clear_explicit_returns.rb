require "spec_helper"

describe RubyTransform::Transformers::ClearExplicitReturns.new do
  
  describe "a method with explicit return" do
    subject { %{
      def my_method
        a = 1
        call_something(a)
        return a
      end
    }}
    
    it { should transform_to("no return", %{
      def my_method
        a = 1
        call_something(a)
        a
      end
    }) }
  end
  
end

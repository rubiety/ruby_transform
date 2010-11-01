require "spec_helper"

describe RubyTransform::Transformer.new do
  
  describe "a for block" do
    subject { %{
      def my_method
        call_something
      
        for element in array
          do_something(element)
        end
      end
    }}
    
    it { should transform_to("the same", %{
      def my_method
        call_something
      
        for element in array
          do_something(element)
        end
      end
    }) }
  end
  
end

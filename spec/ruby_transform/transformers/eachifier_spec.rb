require "spec_helper"

describe RubyTransform::Transformers::Eachifier.new do
  
  describe "a for block" do
    subject { %{
      def my_method
        call_something
      
        for element in array
          do_something(element)
        end
      end
    }}
    
    it { should transform_to("each", %{
      def my_method
        call_something
        
        array.each do |element|
          do_something(element)
        end
      end
    }) }
  end
  
end

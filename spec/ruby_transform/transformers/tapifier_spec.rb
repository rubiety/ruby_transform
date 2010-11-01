require 'spec_helper'

describe RubyTransform::Transformers::Tapifier.new do
  
  describe "a method setting up and returning a temporary variable" do
    subject {%{
      def my_method
        temp = ""
        temp << "Something"
        call_something(temp)
        temp
      end
    }}
    
    it { should transform_to("wrap in #tap", %{
      def my_method
        "".tap do |temp|
          temp << "Something"
          call_something(temp)
        end
      end
    }) }
  end
  
  describe "a method setting up and explicitly returning a temporary variable" do
    subject {%{
      def my_method
        temp = ""
        temp << "Something"
        call_something(temp)
        return temp
      end
    }}
    
    it { should transform_to("wrap in #tap", %{
      def my_method
        "".tap do |temp|
          temp << "Something"
          call_something(temp)
        end
      end
    }) }
  end
  
  describe "a method setting up and not returning a temporary variable" do
    subject {%{
      def my_method
        temp = ""
        temp << "Something"
        call_something(temp)
      end
    }}
    
    it { should transform_to("itself", subject) }
  end
  
end

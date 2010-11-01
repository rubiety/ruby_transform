require 'spec_helper'

transformer = RubyTransform::Transformers::Composite.new([
  RubyTransform::Transformers::Eachifier.new,
  RubyTransform::Transformers::BlockMethodToProcifier.new,
  RubyTransform::Transformers::Tapifier.new
])

describe(transformer) do
  
  describe "a block call with method invocation" do
    subject { %{collection.map {|d| d.name }}}
    it { should transform_to("use Symbol#to_proc", %{collection.map(&:name)}) }
  end
  
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
  # 
  # describe "a method setting up and returning a temporary variable" do
  #   subject {%{
  #     def my_method
  #       temp = ""
  #       temp << "Something"
  #       call_something(temp)
  #       temp
  #     end
  #   }}
  #   
  #   it { should transform_to("wrap in #tap", %{
  #     def my_method
  #       "".tap do |temp|
  #         temp << "Something"
  #         call_something(temp)
  #       end
  #     end
  #   }) }
  # end
  
end

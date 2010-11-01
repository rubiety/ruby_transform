module RubyTransform
  module Transformers
    
    # = For to Each Block Transform
    # Finds instances using "for something in collection"-style of iteration and converts
    # it to using a standard collection.each block.
    #
    # Example:
    #   
    #   for element in collection
    #     do_something(element)
    #   end
    # 
    # Converts To:
    # 
    #   collection.each do |element|
    #     do_something(element)
    #   end
    # 
    class Eachifier < Transformer
      def transform(e)
        super(transform_fors_to_eaches(e))
      end
      
      def transform_fors_to_eaches(e)
        if sexp?(e) && e.kind == :for
          transform_for_to_each(e)
        else
          e
        end
      end
      
      def transform_for_to_each(e)
        s(:iter, 
          s(:call, e.body[0], :each, s(:arglist)), 
          e.body[1],
          e.body[2]
        )
      end
    end
    
  end
end
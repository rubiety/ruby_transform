module RubyTransform
  module Transformers
    
    # = Clear Explicit Returns
    # Looks for cases where the last expression in a method contains an explicit "return" statement, which is unnecessary
    # in ruby, and removes it.
    # 
    # Example:
    # 
    #   def my_method
    #     a = 1
    #     call_something(a)
    #     return a
    #   end
    # 
    # Transforms To:
    #   
    #   def my_method
    #     a = 1
    #     call_something(a)
    #     a
    #   end
    #
    class ClearExplicitReturns < RubyTransform::Transformer
      def transform(e)
        super(transform_explicit_returns(e))
      end
      
      def transform_explicit_returns(e)
        if matches_explicit_return_method?(e)
          transform_explicit_return_method(e)
        else
          e
        end
      end
      
      def matches_explicit_return_method?(e)
        e.is_a?(Sexp) && e.method? && e.block && e.block.body.last && e.block.body.last.kind == :return
      end
      
      def transform_explicit_return_method(e)
        e.clone.tap do |exp|
          exp.block[-1] = exp.block[-1].body[0]
        end
      end
    end
    
  end
end

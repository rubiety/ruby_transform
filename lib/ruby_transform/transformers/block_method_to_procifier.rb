module RubyTransform
  module Transformers
    
    # = Block Method To Proc Transform
    # Looks for cases where we're calling a single method on a single-parameter block argument.
    # These instances can use the Ruby 1.9 and ActiveSupport "Symbol#to_proc" trick.
    # 
    # Example:
    # 
    #   collection.map {|d| d.name }
    # 
    # Transforms To:
    #   
    #   collect.map(&:name)
    # 
    class BlockMethodToProcifier < Transformer
      def transform(e)
        super transform_block_methods_to_proc(e)
      end
      
      def transform_block_methods_to_proc(e)
        if sexp?(e) && matches_block_to_use_tap?(e)
          transform_block_to_use_tap(e)
        else
          e
        end
      end
      
      def matches_block_to_use_tap?(e)
        e.kind == :iter &&  # Calls block
        e.body[2] && e.body[2].kind == :call &&  # Body of block is a simple method call
        e.body[2] && e.body[2].body[0] && e.body[2].body[0].kind == :lvar &&  # Simple method call is on a local variable
        e.body[1] && e.body[1].kind == :lasgn &&  # Block parameter is a single assign
        e.body[2] && e.body[2].body[0].body[0] == e.body[1].body[0]  # Local variable is identical to the first block argument
      end
      
      def transform_block_to_use_tap(e)
        s(:call, 
          e.body[0].body[0], 
          e.body[0].body[1], 
          s(:arglist, s(:block_pass, s(:lit, e.body[2].body[1])))
        )
      end
    end
    
  end
end
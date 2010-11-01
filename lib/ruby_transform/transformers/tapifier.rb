module RubyTransform
  module Transformers
    
    # = Method Temporary Variables to Tap Block
    # Looks for instances of method declarations where:
    # 1. A local variable is assigned to something as the first statement.
    # 2. As the last statement, that local variable is returned is expressed.
    # 
    # These instances of using "temporary variables" to construct something for returning can be more 
    # elegantly expressed by using the .tap idiom.
    #
    # Example:
    # 
    #   def my_method
    #     temp = ""
    #     temp << "Something"
    #     call_something(temp)
    #     temp
    #   end
    # 
    # Converts To:
    # 
    #   def my_method
    #     "".tap do |temp|
    #       temp << "Something"
    #       call_something(temp)
    #     end
    #   end
    # 
    class Tapifier < Transformer
      def transform(e)
        super(transform_tapify_candidates(e))
      end
      
      def transform_tapify_candidates(e)
        if matches_method_to_use_tap?(e)
          transform_method_to_use_tap(e)
        else
          e
        end
      end
      
      def matches_method_to_use_tap?(e)
        e.is_a?(Sexp) && [:defn, :defs].include?(e.kind) && 
        matches_block_to_use_tap?(e.body[2])
      end
      
      def matches_block_to_use_tap?(e)
        return matches_block_to_use_tap?(e.body[0]) if e.body.size == 1 && e.body[0].kind == :block
        
        e.is_a?(Sexp) && e.kind == :block &&   # Some block (or method body)
        e.body[0].kind == :lasgn &&  # The first line assigns to a local variable
        expresses_local_variable?(e.body[-1], e.body[0].body[0])
      end
      
      def expresses_local_variable?(e, local_variable)
        (e.kind == :lvar && e.body[0] == local_variable) ||
        (e.kind == :return && expresses_local_variable?(e.body[0], local_variable))
      end
      
      def transform_method_to_use_tap(e)
        s(e.kind, e.body[0], e.body[1], transform_block_to_use_tap(e.body[2]))
      end
      
      def transform_block_to_use_tap(e)
        return s(:scope, transform_block_to_use_tap(e.body[0])) if e.body.size == 1 && e.kind == :scope && e.body[0].kind == :block
        
        s(:block, s(:iter, 
          s(:call, e.body[0].body[1], :tap, s(:arglist)),
          s(:lasgn, e.body[0].body[0]),
          s(*([:block] + e.body[1..-2]))
        ))
      end
    end
    
  end
end
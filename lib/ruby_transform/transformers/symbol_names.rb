module RubyTransform
  module Transformers
    
    # = Symbol Names
    # Sometimes you'll come across code written by a Java developer who uses camel-cased names for variables and methods.
    # This transformer will allow you to apply some transformation (defined through a block to initialize) to every symbol name
    # in the application, which includes all of these:
    # * Method Names (Definitions and Calls)
    # * Local Variable Names
    # * Instance Variable Names
    # * Class Variable Names
    # 
    # Big Caveat: This transformer does not detect instances where the symbol name is referenced inside an eval-ed string, for example
    # when you are instance_evaling some large string.  As always, run your tests after any transformation.
    # 
    # Example:
    #   
    #   # Underscores symbol names
    #   RubyTransform::Transformers::SymbolNames.new {|name| name.underscore }
    #   
    #   # Given This:
    #   def myMethod
    #     myVariable = 1
    #     @iVar = myMethod(myVariable)
    #   end
    #   
    #   # Translates to This:
    #   def my_method
    #     my_variable = 1
    #     @i_var = my_method(my_variable)
    #   end
    #   
    #   # Or maybe translate from English to French
    #   RubyTransform::Transformers::SymbolNames.new {|name| Google::Translate.new(:fr).translate(name) }
    # 
    class SymbolNames < RubyTransform::Transformer
      def initialize(&block)
        @name_transformer = block
      end
      
      def transform(e)
        super(transform_symbols(e))
      end
      
      def transform_symbols(e)
        return e unless sexp?(e)
        
        case e.kind
        when :defn
          e.clone.tap {|c| c[1] = @name_transformer.call(c[1].to_s).to_sym }
        when :defs
          e.clone.tap {|c| c[2] = @name_transformer.call(c[2].to_s).to_sym }
        when :call
          e.clone.tap {|c| c[2] = @name_transformer.call(c[2].to_s).to_sym }
        when :lasgn, :lvar
          e.clone.tap {|c| c[1] = @name_transformer.call(c[1].to_s).to_sym }
        when :cvdecl, :cvasgn, :cvar
          e.clone.tap {|c| c[1] = ("@@" + @name_transformer.call(c[1].to_s.gsub(/^@@/, ''))).to_sym }
        when :iasgn, :ivar
          e.clone.tap {|c| c[1] = ("@" + @name_transformer.call(c[1].to_s.gsub(/^@/, ''))).to_sym }
        else
          e
        end
      end
    end
    
  end
end
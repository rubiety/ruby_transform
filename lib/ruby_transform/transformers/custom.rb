module RubyTransform
  module Transformers
    
    # = Custom Transformer
    # Allows for implementation of the transform to happen in-line through a block passed to the initializer.
    # 
    # Example:
    # 
    #   # This contrived example reverses all string literals
    #   RubyTransform::Transformers::Custom.new do |expression|
    #     if sexp?(expression) && expression.kind == :str
    #       s(:str, expression.body[0].reverse)
    #     else
    #       super
    #     end
    #   end
    # 
    class Custom < RubyTransform::Transformer
      def initialize(&block)
        class_eval do
          define_method(:transform, &block)
        end
      end
    end
    
  end
end
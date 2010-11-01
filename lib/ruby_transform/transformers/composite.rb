module RubyTransform
  module Transformers
    
    # = Composite Transformer
    # Combines transformations by chaining them.
    # 
    # Example:
    # 
    #   RubyTransform::Transformers::Composite.new([
    #     RubyTransform::Transformers::Eachifier.new,
    #     RubyTransform::Transformers::BlockMethodToProcifier.new,
    #     RubyTransform::Transformers::Tapifier.new
    #   ])
    # 
    class Composite < RubyTransform::Transformer
      def initialize(transformers = [])
        class_eval do
          define_method :transform do |e|
            transformers.inject(e) do |transformed, transformer|
              transformer.transform(transformed)
            end
          end
        end
      end
    end
    
  end
end
module RubyTransform
  
  # Takes a raw S-expression and transforms it (replaces the node with the return value of the process method).
  # This is meant to be subclassed, and in the process method you should either return a transformed version of the node, 
  # or just call super which will leave the node in place and iterate through the children.
  # 
  class Transformer
    include TransformerHelpers
    
    def transform(sexp)
      if sexp.is_a?(Sexp)
        Sexp.new(*([sexp.kind] + sexp.body.map {|c| transform(c) }))
      else
        sexp
      end
    end
  end
end

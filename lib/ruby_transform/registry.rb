module RubyTransform
  class Registry < HashWithIndifferentAccess
    def self.instance
      @registry ||= new
    end
    
    def self.[](name)
      instance[name]
    end
    def self.[]=(name, value)
      instance[name] = value
    end
    
    def self.configure(&block)
      instance.tap do |registry|
        registry.instance_eval(&block) if block
      end
    end
    
    def register(name, transform = nil, &block)
      if block
        self[name.to_s] = RubyTransform::Transformers::Custom.new(&block)
      elsif transform.is_a?(Array)
        self[name.to_s] = RubyTransform::Transformers::Composite.new(transform.map {|t|
          if t.is_a?(Symbol) or t.is_a?(String)
            self[t] or raise ArgumentError, "#{t} is not a registered transform name."
          else
            t
          end
        })
      elsif transform.is_a?(RubyTransform::Transformer)
        self[name.to_s] = transform
      else
        raise ArgumentError, "Please provide a transform or custom block processor."
      end
    end
  end
end

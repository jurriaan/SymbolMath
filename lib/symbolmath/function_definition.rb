module SymbolMath
  class FunctionDefinition
    attr_accessor :name, :block, :display_string, :derivative

    def initialize(name, display_as: nil, &block)
      @name = name.to_sym
      @display_string = display_as || "#{name}(%s)"
      @block = block
      @derivative = derivative
    end

    def to_string(*args)
      format(display_string, args.join(', '))
    end

    def to_proc
      block
    end

    def arity
      block.arity
    end
  end
end

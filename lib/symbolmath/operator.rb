module SymbolMath
  class Operator
    attr_accessor :name

    class << self
      private :new
      def [](symbol)
        OPERATORS[symbol]
      end
    end

    def initialize(name)
      self.name = name.to_sym
    end

    def to_s
      name.to_s
    end

    def inspect
      "<Operator: #{name}>"
    end

    OPERATORS = %i(** * / + -).each_with_object({}) { |op, h| h[op] = new(op) }
  end
end

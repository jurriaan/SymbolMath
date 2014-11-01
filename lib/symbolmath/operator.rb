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
      "<Operator: #{self}>"
    end

    OPERATORS = %i(** * / + -).each_with_object({}) do |op, h|
      h[op] = new(op).freeze
    end.freeze
  end
end

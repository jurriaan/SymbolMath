module SymbolMath
  class RationalExpression < Expression
    attr_accessor :x, :y

    def self.build(x, y)
      new(x, y).simplify
    end

    def initialize(x = nil, y = nil)
      @x = x
      @y = y
    end

    def evaluate(**values)
      (x.respond_to?(:evaluate) ? x.evaluate(values) : x) /
        (y.respond_to?(:evaluate) ? y.evaluate(values) : y)
    end

    def *(other)
      @x *= other
      simplify
    end

    def simplify
      evaluate_elements # TODO: investigate why this is needed

      collapse_rationals

      remove_intersecting_symbols

      simplify_special_cases || self
    end

    def intersecting_symbols
      return [] unless x.respond_to?(:symbols) && y.respond_to?(:symbols)
      x.symbols & y.symbols
    end

    def fdiff(s)
      (x.fdiff(s) * y - x * y.fdiff(s)) / y**2
    end

    def operator
      Operator[:/]
    end

    def elements
      [x, y]
    end

    private

    def simplify_special_cases
      if x == 0
        if y == 0
          NaN
        else
          0
        end
      elsif y == 0
        Infinity
      elsif y == 1
        x
      end
    end

    def evaluate_elements
      @x = x.evaluate if x.is_a?(Expression)
      @y = y.evaluate if y.is_a?(Expression)
    end

    def collapse_rationals
      if x.is_a?(RationalExpression)
        @y *= x.y
        @x = x.x
      end
      if y.is_a?(RationalExpression)
        @x *= y.y
        @y = y.x
      end
    end

    def remove_intersecting_symbols
      intersecting_symbols.each do |symbol|
        return unless x.respond_to?(:symbol_occurances) &&
                      y.respond_to?(:symbol_occurances)
        x_symbols = x.symbol_occurances(symbol)
        y_symbols = y.symbol_occurances(symbol)
        min = [x_symbols, y_symbols].min
        next if min == 0
        @x = x.reduce_symbol(symbol, min)
        @y = y.reduce_symbol(symbol, min)
      end
    end
  end
end

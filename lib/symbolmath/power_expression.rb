module SymbolMath
  class PowerExpression < Expression
    OPERATOR = :*

    attr_accessor :base, :exponent

    def self.build(base, exponent)
      new(base, exponent).simplify
    end

    def initialize(base, exponent)
      @base = base
      @exponent = exponent
    end

    def evaluate(**values)
      eval_base = base.respond_to?(:evaluate) ? base.evaluate(values) : base
      eval_ex = exponent.respond_to?(:evaluate) ? exponent.evaluate(values) : exponent
      res = eval_base**eval_ex
      return res.simplify if res.respond_to?(:simplify)
      res
    end

    def simplify
      if base.is_a?(PowerExpression)
        @exponent *= base.exponent
        @base = base.base
      end

      simplify_special_cases || self
    end

    def simplify_special_cases
      if base.is_a?(ProductExpression) && base.elements.length > 1 &&
         base.elements.first.is_a?(Numeric) && exponent.is_a?(Numeric)
        base.elements.shift**exponent * base.simplify**exponent
      elsif base == 1
        1
      elsif base == 0
        0
      elsif exponent.number?
        if exponent == 0
          1 # 0**0 should be indeterminate
        elsif exponent == 1
          base
        elsif exponent < 0
          1 / (base**(-exponent))
        end
      end
    end

    def symbol_occurances(symbol)
      base.contains_symbol?(symbol) ? exponent : 0
    end

    def reduce_symbol(symbol, count)
      fail 'Unknown Symbol' unless base.contains_symbol?(symbol)
      @exponent -= count
      self
    end

    def fdiff(symbol)
      x = base
      y = exponent
      x**y * y.fdiff(symbol) * Function.log(x) +
        x**(y - 1) * y * x.fdiff(symbol)
    end

    def operator
      Operator[:**]
    end

    def elements
      [base, exponent]
    end
  end
end

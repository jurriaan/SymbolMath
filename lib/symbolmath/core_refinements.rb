module SymbolMath
  module CoreRefinements
    Operator::OPERATORS.keys.each do |operator|
      define_method(operator) do |other|
        if other.is_a?(SymbolLike)
          method = Operators.instance_method(operator)
          method.bind(self).call(other)
        else
          super(other)
        end
      end
    end

    def number?
      true
    end

    def fdiff(_symbol)
      0
    end

    def <=>(other)
      if other.class < SymbolLike
        -other.<=>(self)
      elsif self.class == Complex # TODO: fix this...
        -1
      elsif other.class == Complex
        1
      else
        super
      end
    end
  end

  [Fixnum, Float, Bignum, Rational, Complex, BigDecimal].each do |klass|
    klass.send(:prepend, SymbolMath::CoreRefinements)
  end
end

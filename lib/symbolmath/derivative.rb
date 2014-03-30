module SymbolMath
  class Derivative < Function
    def initialize(function, symbol, number)
      @name = :Deriv
      @arguments = [function, symbol, number]
    end

    def fdiff(symbol)
      return 0 unless contains_symbol?(symbol)
      function, symbol, number = arguments
      res = Derivative.new(function, symbol, number + 1)
      res *= function.arguments.first.fdiff(symbol)
      res.evaluate
    end
  end
end

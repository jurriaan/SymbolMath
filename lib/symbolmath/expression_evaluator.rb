module SymbolMath
  class ExpressionEvaluator < BasicObject
    # Make BasicObject even more basic.
    # source: http://stackoverflow.com/questions/7184571
    instance_methods.each do |meth|
      # skipping undef of methods that "may cause serious problems"
      undef_method(meth) if meth !~ /^(__|instance_exec)/
    end

    def self.exec_lambda(*arguments, &block)
      res = new.instance_exec(*arguments.flatten, &block)
      res.respond_to?(:simplify) ? res.simplify : res
    end

    def method_missing(method, *args, &_block)
      if args.empty?
        Symbol[method]
      elsif method == :Deriv
        Derivative.new(*args)
      elsif %i(Complex BigDecimal Rational Float Integer).include?(method)
        ::Kernel.send(method, *args)
      else
        Function.new(method, *args)
      end
    end
  end
end

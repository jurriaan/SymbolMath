module SymbolMath
  class ExpressionEvaluator < BasicObject
    # Make BasicObject even more basic.
    instance_methods.each do |meth|
      # skipping undef of methods that "may cause serious problems"
      undef_method(meth) if meth !~ /^(__|instance_exec)/
    end

    def self.exec_lambda(*arguments, &block)
      res = new.instance_exec(*arguments.flatten, &block)
      res.respond_to?(:simplify) ? res.simplify : res
    end

    def method_missing(method, *args, &block)
      if args.empty?
        Symbol[method]
      elsif method == :Deriv
        Derivative.new(*args)
      else
        Function.new(method, *args)
      end
    end
  end
end

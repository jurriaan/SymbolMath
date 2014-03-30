module SymbolMath
  class Expression < SymbolLike
    def self.build(&block)
      res = ExpressionEvaluator.new.instance_exec(&block)
      res.respond_to?(:simplify) ? res.simplify : res
    end

    def number?
      elements.reduce(true) { |a, e| a && e.number? }
    end

    def contains_symbol?(symbol)
      elements.each do |element|
        if element.respond_to?(:contains_symbol?) &&
           element.contains_symbol?(symbol)
          return true
        end
      end
      false
    end

    def to_s
      "(#{elements.map(&:to_s).join(" #{operator} ")})"
    end

    def inspect
      "(#{elements.map(&:inspect).join(" #{operator} ")})"
    end
  end
end

module SymbolMath
  class Expression < SymbolLike
    def self.build(&block)
      res = ExpressionEvaluator.new.instance_exec(&block)
      res.respond_to?(:simplify) ? res.simplify : res
    end

    def number?
      elements.all?(&:number?)
    end

    def contains_symbol?(symbol)
      elements.any? do |element|
        element.respond_to?(:contains_symbol?) &&
          element.contains_symbol?(symbol)
      end
    end

    def to_s
      "(#{elements.map(&:to_s).join(" #{operator} ")})"
    end

    def inspect
      "(#{elements.map(&:inspect).join(" #{operator} ")})"
    end
  end
end

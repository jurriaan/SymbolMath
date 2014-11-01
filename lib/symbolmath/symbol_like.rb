module SymbolMath
  module Operators
    def *(other)
      ProductExpression.build(self, other)
    end

    def +(other)
      SumExpression.build(self, other)
    end

    def -(other)
      SumExpression.build(self, -other)
    end

    def /(other)
      RationalExpression.build(self, other)
    end

    def **(other)
      PowerExpression.build(self, other)
    end

    def -@
      (self * -1).simplify
    end

    def +@
      self
    end
  end

  class SymbolLike
    include Comparable
    include Operators

    def simplify
      self
    end

    def number?
      false
    end

    def contains_symbol?(s)
      symbol?(s)
    end

    def symbol?(s)
      s == self
    end

    def evaluate(**_values)
      self
    end

    def subs(symbol, value)
      evaluate(symbol => value)
    end

    def symbols
      elements.reduce([]) do |a, e|
        e.respond_to?(:symbols) ? a + e.symbols : a
      end << self
    end

    def symbol_occurances(s)
      s == self ? 1 : 0
    end

    def maclaurin(symbol, terms = 5)
      taylor(symbol, terms, 0)
    end

    def taylor(symbol, terms = 5, point = 0)
      cur_func = self
      pos = Symbol[symbol] - point
      (0..terms).reduce(0) do |a, e|
        func_eval = cur_func
        func_eval = cur_func.evaluate(x: point) if func_eval.is_a?(SymbolLike)
        term = pos**e * func_eval / Function.fact(e)
        cur_func = cur_func.fdiff(:x)
        cur_func = cur_func.simplify if cur_func.respond_to?(:simplify)
        a + term
      end
    end

    def elements
      []
    end

    def reduce_symbol(_symbol, count)
      fail 'Unknown Symbol' unless symbol?(self)
      if count == 0
        self
      elsif count == 1
        1
      else
        fail 'Reducing this far is not possible on a single ' + self.class.to_s
      end
    end

    def class_compare(other)
      sort = [Numeric, Symbol, Function, SumExpression, ProductExpression,
              PowerExpression, RationalExpression]
      self_index = sort.index { |a| a >= self.class }
      other_index = sort.index { |a| a >= other.class }
      res = self_index <=> other_index
      block_given? && res == 0 ? yield : res
    end

    # could be better..
    def hash
      elements.hash ^ self.class.hash
    end

    def <=>(other)
      class_compare(other) { elements.reverse <=> other.elements.reverse }
    end

    alias_method :eql?, :==

    [:to_i, :to_r, :to_f, :to_c].each do |method_name|
      define_method method_name do
        if number?
          evaluate.send(method_name)
        else
          fail 'Not a number'
        end
      end
    end
  end
end

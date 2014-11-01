module SymbolMath
  class ProductExpression < AbelianExpression
    attr_reader :elements

    def *(other)
      if other.is_a?(SumExpression)
        SumExpression.build(other.elements.map { |e| e * self })
      else
        super
      end
    end

    def symbol_occurances(symbol)
      elements.reduce(0) do |a, e|
        if e.respond_to?(:symbol_occurances)
          a + e.symbol_occurances(symbol)
        else
          a
        end
      end
    end

    def reduce_symbol(symbol, count)
      fail "Unknown Symbol #{symbol}" unless contains_symbol?(symbol)
      index = elements.index do |e|
        e.respond_to?(:symbol_occurances) && e.symbol_occurances(symbol) > 0
      end
      self * elements.delete_at(index).reduce_symbol(symbol, count)
    end

    def fdiff(symbol)
      self * SumExpression.build(elements.map { |el| el.fdiff(symbol) / el })
    end

    def to_s
      if elements.length == 2 && elements.first == -1
        "-#{elements.last}"
      else
        super
      end
    end

    def inspect
      if elements.length == 2 && elements.first == -1
        "-#{elements.last.inspect}"
      else
        super
      end
    end

    def operator
      Operator[:*]
    end

    def identity
      1
    end

    private

    def rationalize
      rational = elements.index { |e| e.is_a?(RationalExpression) }
      return unless rational
      rational = elements.delete_at(rational)
      rational.x *= self
      @elements = [rational.simplify]
    end

    def sumify
      sum = elements.index { |e| e.is_a?(SumExpression) }
      return unless sum
      sum = elements.delete_at(sum)
      @elements = [SumExpression.build(sum.elements.map { |e| self * e })]
    end

    def group_elements
      elements.each_with_object(Hash.new(0)) do |element, group|
        if element.is_a?(Numeric)
          next if element == 1
          group[Numeric] = 1 unless group.include?(Numeric)
          group[Numeric] *= element
        elsif element.is_a?(PowerExpression)
          group[element.base] += element.exponent
        else
          group[element] += 1
        end
      end
    end

    def simplify_elements
      return 0 if elements.include?(0)
      rationalize
      sumify
      self.elements = group_elements.map do |element, count|
        if element == Numeric
          count unless count == 1
        elsif count == 1
          element
        else
          PowerExpression.build(element, count)
        end
      end.compact.sort
      self
    end
  end
end

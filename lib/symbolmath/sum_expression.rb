module SymbolMath
  class SumExpression < AbelianExpression
    attr_reader :elements

    def simplify_elements
      self.elements = group_elements.map do |element, count|
        if count == 0
          next
        elsif Numeric == element
          count unless count == 0
        elsif element.is_a?(RationalExpression)
          element.x = count
          element
        elsif count == 1
          element
        else
          ProductExpression.build(count, element)
        end
      end.compact
      self
    end

    def group_elements
      elements.each_with_object(Hash.new(0)) do |element, group|
        if element.is_a?(Numeric)
          group[Numeric] += element unless element == 0
        elsif element.is_a?(ProductExpression) && element.elements.length > 1
          expression = ProductExpression.build(*element.elements[1..-1])
          group[expression] += element.elements.first
        elsif element.is_a?(RationalExpression)
          group[Rational(1) / element.y] += element.x
        else
          group[element] += 1
        end
      end
    end

    def fdiff(s)
      SumExpression.build(elements.map { |el| el.fdiff(s) })
    end

    def identity
      0
    end

    def operator
      Operator[:+]
    end
  end
end

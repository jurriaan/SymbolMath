module SymbolMath
  # See http://en.wikipedia.org/wiki/Abelian_group
  class AbelianExpression < Expression
    def self.build(*elements)
      new(elements).simplify
    end

    def initialize(elements)
      self.elements = elements
      super()
    end

    def elements=(elements)
      @elements = get_elements(elements.flatten)
    end

    def evaluate(**values)
      elements.reduce(identity) do |a, e|
        e = e.evaluate(values) if e.respond_to?(:evaluate)
        a.send(operator.name, e)
      end
    end

    def simplify
      res = simplify_elements

      if elements.length == 1
        elements.first
      elsif elements.empty?
        identity
      else
        res
      end
    end

    private

    def get_elements(elements)
      elements.reduce([]) do |a, element|
        if element.is_a?(self.class)
          a + get_elements(element.elements)
        else
          a << element
        end
      end.flatten.sort
    end
  end
end

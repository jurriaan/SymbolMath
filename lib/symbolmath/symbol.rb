module SymbolMath
  class Symbol < SymbolLike
    SYMBOLMAP = {
      /(.*)\!$/ => ->(res) { Function.fact Symbol[res] },
      /pi/i => ->(_res) { new :π }
    }

    SYMBOLMAP.default_proc = lambda do |hash, lookup|
      hash.each_pair do |key, value|
        return value.call(Regexp.last_match[1]) if lookup.to_s =~ key
      end
      return SymbolMath::Symbol.new(lookup)
    end

    attr_accessor :name

    def self.[](name)
      return name if name.is_a? Symbol
      SYMBOLMAP[name]
    end

    def initialize(name)
      self.name = name.to_sym
    end

    def to_s
      name.to_s
    end

    def inspect
      "<Symbol: #{self}>"
    end

    def symbol?(symbol)
      symbol == name || super
    end

    def symbol_occurances(symbol)
      contains_symbol?(symbol) ? 1 : 0
    end

    def symbols
      [self]
    end

    def evaluate(**values)
      values.include?(name) ? values[name] : self
    end

    def fdiff(symbol)
      symbol?(symbol) ? 1 : 0
    end

    alias_method :eql?, :==

    def hash
      name.hash
    end

    def <=>(other)
      class_compare(other) { name <=> other.name }
    end
  end
end

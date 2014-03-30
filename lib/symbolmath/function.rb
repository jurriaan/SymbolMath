module SymbolMath
  class Function < SymbolLike
    @definitions = {}

    class << self
      def method_missing(name, *args, &block)
        if @definitions.include?(name)
          if args.length == @definitions[name].arity
            return new(name, *args)
          elsif args.empty?
            return @definitions[name]
          end
        end
        super
      end

      def define(name, **options, &block)
        @definitions[name] = FunctionDefinition.new(name, options, &block)
      end

      def [](name)
        @definitions[name]
      end
    end

    attr_accessor :name, :arguments, :definition

    def initialize(name, *arguments)
      @name = name.to_sym
      @definition = Function[name]
      @arguments = Array(arguments)
    end

    def to_s(func = :to_s)
      if definition
        definition.to_string(*arguments.map(&func))
      else
        name.to_s + "(#{arguments.map(&func).join(', ')})"
      end
    end

    def inspect
      "<Function: #{to_s(:inspect)}>"
    end

    def evaluate(**values)
      args = evaluated_arguments(values)
      return self unless number?(args)
      ExpressionEvaluator.exec_lambda(*args, &definition.to_proc)
    end

    def number?(args = arguments)
      return false if args.empty?
      args.each { |a| return false unless a.number? }
      true
    end

    def contains_symbol?(s)
      return true if s == self
      arguments.each { |a| return true if !a.number? && a.contains_symbol?(s) }
      false
    end

    def <=>(other)
      class_compare(other) do
        [name, *arguments] <=> [other.name, *other.arguments]
      end
    end

    def fdiff(s)
      return 0 unless contains_symbol?(s)
      if definition && definition.derivative
        derivative = definition.derivative
        ExpressionEvaluator.exec_lambda(*arguments, &derivative)
      else
        Derivative.new(self, Symbol[s], 1)
      end * arguments.first.fdiff(s)
    end

    def hash
      name.hash ^ arguments.hash
    end

    private

    def evaluated_arguments(**values)
      arguments.map do |arg|
        arg.respond_to?(:evaluate) ? arg.evaluate(values) : arg
      end
    end
  end
end

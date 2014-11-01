require 'bigdecimal'
require 'bigdecimal/math'
require 'complex'
require 'cmath'
require 'symbolmath/version'
require 'symbolmath/operator'
require 'symbolmath/symbol_like'
require 'symbolmath/core_refinements'
require 'symbolmath/symbol'
require 'symbolmath/function'
require 'symbolmath/function_definition'
require 'symbolmath/function_definitions'
require 'symbolmath/derivative'
require 'symbolmath/expression_evaluator'
require 'symbolmath/expression'
require 'symbolmath/abelian_expression'
require 'symbolmath/product_expression'
require 'symbolmath/sum_expression'
require 'symbolmath/rational_expression'
require 'symbolmath/power_expression'

# The SymbolMath module
module SymbolMath
  Infinity = BigDecimal::INFINITY
  NaN = BigDecimal::NAN

  module_function

  def expr(&block)
    Expression.build(&block)
  end
end

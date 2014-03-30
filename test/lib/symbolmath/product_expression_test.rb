require_relative '../../test_helper'

describe SymbolMath::ProductExpression do
  it 'should simplify equations' do
    s = SymbolMath::Symbol[:a]
    SymbolMath::ProductExpression.build(5, 0).must_equal 0
    SymbolMath::ProductExpression.build(5, 1).must_equal 5
    SymbolMath::ProductExpression.build(0, 100).must_equal 0
    SymbolMath::ProductExpression.build(0, 0).must_equal 0
    SymbolMath::ProductExpression.build(s, 1).must_equal s
    SymbolMath::ProductExpression.build(s, 0).must_equal 0
    SymbolMath::ProductExpression.build(s, s).must_equal SymbolMath::PowerExpression.build(s, 2)
    SymbolMath::ProductExpression.build(s, s, s).must_equal SymbolMath::PowerExpression.build(s, 3)
  end
end

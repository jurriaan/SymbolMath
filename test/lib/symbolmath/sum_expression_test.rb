require_relative '../../test_helper'

describe SymbolMath::SumExpression do
  it 'should simplify equations' do
    s = SymbolMath::Symbol[:a]
    SymbolMath::SumExpression.build(5, 0).must_equal 5
    SymbolMath::SumExpression.build(5, 1).must_equal 6
    SymbolMath::SumExpression.build(0, 100).must_equal 100
    SymbolMath::SumExpression.build(0, 0).must_equal 0
    SymbolMath::SumExpression.build(s, 1).must_equal build { a + 1 }
    SymbolMath::SumExpression.build(s, 0).must_equal s
    SymbolMath::SumExpression.build(s, s).must_equal SymbolMath::ProductExpression.build(s, 2)
    SymbolMath::SumExpression.build(s, s, s).must_equal SymbolMath::ProductExpression.build(s, 3)
  end
end

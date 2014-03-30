require_relative '../../test_helper'

describe SymbolMath::PowerExpression do
  it 'should simplify equations' do
    s = SymbolMath::Symbol[:a]
    SymbolMath::PowerExpression.build(5, 0).must_equal 1
    SymbolMath::PowerExpression.build(5, 1).must_equal 5
    SymbolMath::PowerExpression.build(1, 100).must_equal 1
    SymbolMath::PowerExpression.build(1, 0).must_equal 1
    SymbolMath::PowerExpression.build(1, s).must_equal 1
    SymbolMath::PowerExpression.build(0, 100).must_equal 0
    # SymbolMath::PowerExpression.build(0,0).wont_equal 1 # ruby will evaluate this...
    SymbolMath::PowerExpression.build(s, 1).must_equal s
    SymbolMath::PowerExpression.build(s, 0).must_equal 1 # indeterminate..
    SymbolMath::PowerExpression.build(s, -1).must_equal build { 1 / s }
    (SymbolMath::PowerExpression.build(s, 2)**3).must_equal build { s**6 }
  end

  it 'should differentiate correctly' do
    s = SymbolMath::Symbol[:a]
    SymbolMath::PowerExpression.new(s, 1).fdiff(:a).must_equal 1
    SymbolMath::PowerExpression.new(s, 2).fdiff(:a).must_equal build { 2 * s }
    SymbolMath::PowerExpression.new(s, 3).fdiff(:a).must_equal build { 3 * s**2 }
    SymbolMath::PowerExpression.new(s, -1).fdiff(:a).must_equal build { -1 / (s**2) }
  end
end

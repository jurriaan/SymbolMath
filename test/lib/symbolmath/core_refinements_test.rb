require_relative '../../test_helper'

describe SymbolMath::CoreRefinements do
  it 'should create a correct expression' do
    subject = 2 * SymbolMath::Symbol[:a] + SymbolMath::Symbol[:c]
    subject.must_equal build { 2 * a + c }
  end

  it 'should evaluate correctly' do
    SymbolMath.expr { 3i * x }.evaluate(x: 2i).must_equal(-6)
  end

  it 'should not bother with normal calculations' do
    (Math.sqrt(7056) / 2).must_equal(42)
  end
end

require_relative '../test_helper'

describe SymbolMath do
  it 'should create an expression' do
    SymbolMath.expr { a * b }.must_equal build { a * b }
  end
end

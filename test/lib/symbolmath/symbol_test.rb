require_relative '../../test_helper'

describe SymbolMath::Symbol do
  it 'should be equal to the same symbol' do
    d = SymbolMath::Symbol[:hi]
    e = SymbolMath::Symbol[:hi]
    d.must_equal(e)
    e.wont_equal(SymbolMath::Function.new(:hi))
  end

  it 'should evaluate to the correct value' do
    sym = SymbolMath::Symbol[:hi]
    sym.evaluate(a: 105, hi: 24).must_equal(24)
    sym.evaluate.must_equal(sym)
  end

  it 'supports negative/positive symbols' do
    sym = -SymbolMath::Symbol[:a]
    sym.evaluate(a: 5).must_equal(-5)
    sym = +SymbolMath::Symbol[:a]
    sym.evaluate(a: 5).must_equal(5)
  end

  it 'should create an expression when combined' do
    d = SymbolMath::Symbol[:a]
    e = SymbolMath::Symbol[:b]
    (d * e).must_equal build { a * b }
  end

  it 'should reduce correctly' do
    d = SymbolMath::Symbol[:a]
    d.reduce_symbol(:a, 1).must_equal 1
    d.reduce_symbol(:a, 0).must_equal d
    -> { d.reduce_symbol(:a, 2) }.must_raise(RuntimeError) # TODO: is this ok?
  end

  it 'should not be convertable to a number' do
    d = SymbolMath::Symbol[:a]
    -> { d.to_i }.must_raise(RuntimeError) # TODO: is this ok?
    -> { d.to_f }.must_raise(RuntimeError) # TODO: is this ok?
    -> { d.to_c }.must_raise(RuntimeError) # TODO: is this ok?
    -> { d.to_r }.must_raise(RuntimeError) # TODO: is this ok?
  end

  it 'should create a factorial function when a bang is appended' do
    SymbolMath::Symbol[:ab!].must_equal build { fact(ab) }
    SymbolMath::Symbol[:ab!].to_s.must_equal 'ab!'
  end

  it 'should return the symbol name when inspected' do
    SymbolMath::Symbol[:weird_name].inspect.must_match(/weird_name/)
  end

  it 'should not be a number' do
    SymbolMath::Symbol[:a].number?.must_equal(false)
  end
end

require_relative '../../test_helper'

describe SymbolMath::Function do
  it 'should be equal to the same symbol' do
    d = SymbolMath::Function.new(:sin, 1)
    e = SymbolMath::Function.new(:sin, 1)
    d.to_s.must_equal('sin(1)')
    d.must_equal(e)
  end

  it 'should evaluate to the correct value' do
    sym = +SymbolMath::Function.new(:identity, 8)
    sym.evaluate.must_equal(8)
  end

  it 'supports negative/positive functions' do
    sym = -SymbolMath::Function.new(:identity, 3)
    sym.evaluate.must_equal(-3)
    sym = +SymbolMath::Function.new(:identity, 1)
    sym.evaluate.must_equal(1)
  end

  it 'should create an expression when combined' do
    d = SymbolMath::Function.new(:sin, -2)
    e = SymbolMath::Function.new(:cos, 2)
    (d * e).must_equal build { sin(-2) * cos(2) }
  end

  it 'should return the function name and args when inspected' do
    subject = SymbolMath::Function.new(:weird_name, 42).inspect
    subject.must_match(/weird_name/)
    subject.must_match(/42/)
  end

  it 'should be convertable to a number' do
    d = SymbolMath::Function.new(:log, Math::E**2)
    d.to_i.must_equal 2
    d.to_f.must_equal 2
    d.to_c.must_equal 2
    d.to_r.must_equal 2

    d = SymbolMath::Function.new(:log, SymbolMath::Symbol[:huh])
    -> { d.to_i }.must_raise(RuntimeError) # TODO: is this ok?
    -> { d.to_f }.must_raise(RuntimeError) # TODO: is this ok?
    -> { d.to_c }.must_raise(RuntimeError) # TODO: is this ok?
    -> { d.to_r }.must_raise(RuntimeError) # TODO: is this ok?
  end

  it 'should know what is a number and what not' do
    SymbolMath::Function.new(:weird_name, 42).number?.must_equal(true)
    SymbolMath::Function.new(:weird_name, SymbolMath::Symbol[:huh]).number?.must_equal(false)
  end

  it 'should be possible to differentiate a unknown function' do
    subject = build { unknown(s) }.fdiff(:s)
    subject.must_equal(build { Deriv(unknown(s), s, 1) })
    subject.fdiff(:s).must_equal(build { Deriv(unknown(s), s, 2) })
    subject = build { unknown(s**2) }.fdiff(:s)
    subject.must_equal(build { 2 * s * Deriv(unknown(s**2), s, 1) })
    subject.fdiff(:s).must_equal(build { 2 * Deriv(unknown(s**2), s, 1) + 4 * s**2 * Deriv(unknown(s**2), s, 2) })
  end

  it 'should know the difference between functions' do
    build { log(42) }.wont_equal(build { log(1337) })
    build { Deriv(unknown(s), s, 3) }.wont_equal(build { Deriv(unknown(s), s, 1) })
  end
end

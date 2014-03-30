require_relative '../../test_helper'

describe SymbolMath::FunctionDefinition do
  it 'should have some functions predefined' do
    build { sin(x) }.fdiff(:x).must_equal build { cos(x) }
    build { cos(x) }.fdiff(:x).must_equal build { -sin(x) }
    build { tan(x) }.fdiff(:x).must_equal build { 1 / cos(x)**2 }
    build { tan(x) }.evaluate(x: Math::PI / 4).must_be_within_delta(1, 10**-8)
    build { identity(x) }.fdiff(:x).must_equal 1
    build { fact(x) }.evaluate(x: 5).must_equal 120
    build { cosh(x)**2 - sinh(x)**2 }.evaluate(x: 5).must_be_within_delta(1, 10**-8)
    ex = Math.exp(1)
    mex = Math.exp(-1)
    build { tanh(x) }.evaluate(x: 1).must_be_within_delta((ex - mex) / (ex + mex), 10**-8)
    build { sin(x) }.evaluate(x: 0).must_be_within_delta(0, 10**-8)
    build { cos(x) }.evaluate(x: 0).must_be_within_delta(1, 10**-8)
    build { fact(x) }.evaluate(x: 3r / 2).must_be_within_delta(Math.sqrt(Math::PI), 10**-8)
  end

  it 'can do complex trigonometric' do
    build { sin(x) }.evaluate(x: 2i).must_be_within_delta(build { -sin(x) }.evaluate(x: 2i + Math::PI), 10**-8)
    build { sin(x) }.evaluate(x: 2i).must_be_within_delta(3.6268604i, 10**-8)
  end

end

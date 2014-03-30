require_relative '../../test_helper'

describe SymbolMath::RationalExpression do
  it 'should simplify equations' do
    s = SymbolMath::Symbol[:a]
    SymbolMath::RationalExpression.build(5, 0).must_equal SymbolMath::Infinity
    SymbolMath::RationalExpression.build(5, 1).must_equal 5
    SymbolMath::RationalExpression.build(0, 100).must_equal 0
    SymbolMath::RationalExpression.build(s, 1).must_equal s
    SymbolMath::RationalExpression.build(0, s).must_equal 0
    SymbolMath::RationalExpression.build(s, s).must_equal 1
    SymbolMath::RationalExpression.build(0, 0).nan?.must_equal true
    SymbolMath::RationalExpression.build(1, SymbolMath::PowerExpression.build(s, -1)).must_equal s
  end

  it 'should evaluate equations' do
    s = SymbolMath::Symbol[:a]
    SymbolMath::RationalExpression.build(Rational(5), s).evaluate(a: Rational(3)).must_equal Rational(5, 3)
    SymbolMath::RationalExpression.build(s, Rational(5)).evaluate(a: Rational(3)).must_equal Rational(3, 5)
  end

  it 'should remove useless symbols' do
    y = build { a * b * c * d * e }
    z = build { d * e * f * g * h }
    subject = SymbolMath::RationalExpression.build(y, z)
    subject.must_equal build { (a * b * c) / (f * g * h) }
    subject.intersecting_symbols.empty?.must_equal true
  end

  it 'should differentiate correctly' do
    s = SymbolMath::Symbol[:a]
    SymbolMath::RationalExpression.build(s, Rational(5)).fdiff(:a).must_equal Rational(1, 5)
    SymbolMath::RationalExpression.build(s**2 + 3, s).must_equal build { (3 + a**2) / a }
  end
end

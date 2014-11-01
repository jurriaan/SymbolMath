require_relative '../../test_helper'

describe SymbolMath::Expression do
  it 'should run in a clean environment' do
    subject = build { fail * fork }
    subject.elements.first.must_equal SymbolMath::Symbol[:fail]
    subject.elements.last.must_equal SymbolMath::Symbol[:fork]
  end

  it 'should parse a*b' do
    subject = build { a * b }
    subject.elements.first.must_equal SymbolMath::Symbol[:a]
    subject.elements.last.must_equal SymbolMath::Symbol[:b]
    subject.contains_symbol?(:a).must_equal(true)
    subject.contains_symbol?(:c).must_equal(false)
    subject.must_be_instance_of(SymbolMath::ProductExpression)
    subject.to_s.must_equal '(a * b)'
    subject.inspect.must_equal '(<Symbol: a> * <Symbol: b>)'
  end

  it 'should create a correct representation of a relative complex equation' do
    subject = build { a + a / b / c * d * e * d - 2 * a }
    subject.to_s.must_equal '(-a + ((a * e * (d ** 2)) / (b * c)))'
    subject.inspect.must_equal '(-<Symbol: a> + ((<Symbol: a> * <Symbol: e> * (<Symbol: d> ** 2)) / (<Symbol: b> * <Symbol: c>)))'
  end

  it 'should evaluate expressions correctly' do
    subject = build { a**b + 3 - a }
    subject.evaluate.must_equal(subject)
    subject = build { abs(3.0 / 2.0 + a) }
    subject.evaluate(a: Complex(0, 2)).must_equal(2.5)
    subject.evaluate.must_equal(subject)
    subject = SymbolMath::ExpressionEvaluator.exec_lambda do
      [
        [x, 1],
        [y, 2],
        [+x, 1],
        [-x, -1],
        [x + 4, 5],
        [3 + x, 4],
        [x + y, 3],
        [x - 1, 0],
        [1 - x, 0],
        [x - y, -1],
        [-x + 3, 2],
        [-y - x, -3],
        [x * 3, 3],
        [4 * y, 8],
        [(+x) * (-y), -2],
        [x / 2, 0.5],
        [y / 2, 1],
        [-2 / x, -2],
        [4 / (-y), -2],
        [x**2, 1],
        [4**y, 16],
        [y**x, 2],
        [x - (y + x) / 5, Rational(2, 5)]
      ]
    end

    subject.each do |item|
      expression, result = item
      expression = expression.simplify # Expressions are always simplified before returning
      expression.evaluate.must_equal(expression)
      expression.evaluate(x: Rational(1), y: Rational(2)).must_equal(result)
    end

  end

  it 'should parse functions' do
    subject = build { random_function_thing(a) }
    subject.must_be_instance_of(SymbolMath::Function)
    subject.arguments.must_equal [SymbolMath::Symbol[:a]]
  end

  it 'should be equal to the same expression' do
    d = build { a * b }
    e = build { a * b }
    f = build { a * g / 3 }
    d.must_equal(e)
    d.wont_equal(f)
    build { (((a + b) + c) + n) }.must_equal(build { (a + b) + (c + n) })
    build { x - (y + x) / 5 }.must_equal build { ((Rational(4, 5) * x) + (Rational(-1, 5) * y)) }
  end

  it 'can compute the series of a given equation' do
    a = build { sin(x) }
    b = build { x**3 }
    a.maclaurin(:x, 5).must_equal build { ((x / fact(1)) + (-(x**3) / fact(3)) + ((x**5) / fact(5))) }
    b.taylor(:x, 4, 1).must_equal build { ((1 / fact(0)) + ((-3 + (3 * x)) / fact(1)) + ((6 * ((-1 + x)**2)) / fact(2)) + ((6 * ((-1 + x)**3)) / fact(3))) }
  end

  it 'should know what is a number and what not' do
    build { log(2) / log(3) }.number?.must_equal true
    build { Complex(0, 3) / 2 + sin(a) }.number?.must_equal false
    build { Complex(0, 3) / 2 + log(3)  }.number?.must_equal true
    build { Rational(4, 2) + log(3) - Complex(0, 3) }.number?.must_equal true
  end

  it 'should simplify equations' do
    subject = SymbolMath::ExpressionEvaluator.exec_lambda do
      [
        [x + x + x + x, 4 * x],
        [-(-x),        x],
        [0 + x,        x],
        [x + 0,        x],
        [x + (-2),     x - 2],
        [-2 + x,       x - 2],
        [-x + 2,       2 - x],
        [x + (-y),     x - y],
        [-y + x,       x - y],
        [0 - x,        -x],
        [x - 0,        x],
        [x - (-2),     x + 2],
        [-2 - (-x),    x - 2],
        [x - (-y),     x + y],
        [0 * x,        0],
        [x * 0,        0],
        [1 * x,        x],
        [x * 1,        x],
        [-1 * x,       -x],
        [x * (-1),     -x],
        [x * (-3),     -(x * 3)],
        [-3 * x,       -(x * 3)],
        [-3 * (-x),    x * 3],
        [x * (-y),       -(x * y)],
        [-x * y,         -(x * y)],
        [(-x) * (-y),    x * y],
        [0 / x,        0],
        [x / 1,        x],
        [x / x,        1],
        [x / 0,        SymbolMath::Infinity],
        [0**x,         0],
        [1**x,         1],
        [x**0,         1],
        [x**1,         x],
        [(x**9)**5,    x**45],
        [(-x)**1,      -x],
        [(-x)**2,      x**2],
        [(x**2)**y,    x**(2 * y)],
        [x * 4 * x,        4 * x**2],
        [x * (-1) * x**(-1), -1],
        [x**2 * (-1) * x**(-1), -x],
        [x + y - x, y],
        [2 * x + x**1 - y**2 / y - y, 3 * x - 2 * y],
        [-(x + 4), -x - 4],
        [(x / y) / (x / y), 1],
        [(y / x) / (x / y), y**2 / x**2],
        [x - (y + x) / 5, 0.8 * x - 0.2 * y]
      ]
    end

    subject.each do |item|
      expression, result = item
      expression = expression.simplify if expression.respond_to? :simplify
      expression.must_equal(result)
    end
  end

  it 'should differentiate correctly' do
    build { b + b + b + b }.fdiff(:b).must_equal 4
    build { b * b }.fdiff(:b).must_equal build { 2 * b }
    build { b * log(a) }.fdiff(:b).must_equal build { log(a) }
    build { b * log(b) }.fdiff(:b).must_equal build { log(b) + 1 }
    build { 1 / x }.fdiff(:x).must_equal build { -1 / (x**2) }
    build { ((1 / x) - d) * x }.fdiff(:x).must_equal build { -d }
    build { ((1 / x) - d) * x * x }.fdiff(:x).must_equal build { 1 - 2 * (x * d) }
    build { (5 * x**2 + 2 * x + 6) }.fdiff(:x).must_equal build { (10 * x) + 2 }
    build { 2 * x**2 - 1 / (x**2) }.fdiff(:x).must_equal build { 4 * x + 2 / (x**3) }
    build { (x - 2) / (x + 1) }.fdiff(:x).must_equal build { 3 / ((x + 1)**2) }
    build { (17 * x**2 - 5 * x)**50 }.fdiff(:x).must_equal build { 50 * (17 * x**2 - 5 * x)**49 * (34 * x - 5) }
    build { pi / (e**x + e**-x) }.fdiff(:x).evaluate(e: Math::E).must_equal build { - (pi * (e**x - e**-x) / ((e**x + e**-x)**2)).evaluate(e: Math::E) }
  end
end

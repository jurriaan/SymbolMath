module SymbolMath
  Function.define :sin do |x|
    x == 0 ? 0 : CMath.sin(x)
  end
  Function.sin.derivative = ->(x) { cos(x) }
  Function.define :abs do |x|
    x.abs
  end
  Function.define :log do |x|
    CMath.log(x)
  end
  Function.log.derivative = ->(x) { 1 / x }
  Function.define :cos do |x|
    x == 0 ? Rational(1) : CMath.cos(x)
  end
  Function.cos.derivative = ->(x) { - sin(x) }
  Function.define :tan do |x|
    CMath.tan(x)
  end
  Function.tan.derivative = ->(x) { cos(x)**(-2) }
  Function.define :sinh do |x|
    CMath.sinh(x)
  end
  Function.define :cosh do |x|
    CMath.cosh(x)
  end
  Function.define :tanh do |x|
    CMath.tanh(x)
  end
  Function.define :identity do |x|
    x
  end
  Function.identity.derivative = ->(x) { 1 }
  Function.define :fact, display_as: '%s!' do |x|
    if x.is_a?(Integer) && x >= 0
      (1..x).reduce(:*) || 1
    else
      Math.gamma(x - 1)
    end
  end
end

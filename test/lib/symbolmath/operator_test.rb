require_relative '../../test_helper'

describe SymbolMath::Operator do
  it 'should be equal to the same operator' do
    d = SymbolMath::Operator[:*]
    e = SymbolMath::Operator[:*]
    f = SymbolMath::Operator[:/]
    d.must_equal(e)
    d.to_s.must_equal '*'
    d.inspect.must_equal '<Operator: *>'
    e.wont_equal(SymbolMath::Function.new(:*)) # you don't want this
    SymbolMath::Function.new(:*).wont_equal(e)
    f.wont_equal(d)
  end

  it 'should only instanciate correct operator' do
    sym = SymbolMath::Operator[:eql?]
    sym.must_equal nil
  end

  it 'should return the operator name when inspected' do
    SymbolMath::Symbol[:**].inspect.must_match(/\*\*/)
  end
end

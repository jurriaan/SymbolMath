require_relative '../../test_helper'

describe SymbolMath::ExpressionEvaluator do
  it 'should run in a clean environment' do
    subject = SymbolMath::ExpressionEvaluator.exec_lambda { fail * fork }
    subject.elements.first.must_equal SymbolMath::Symbol[:fail]
    subject.elements.last.must_equal SymbolMath::Symbol[:fork]
  end
end

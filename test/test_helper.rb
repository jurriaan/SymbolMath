require 'simplecov'
require 'coveralls'
Coveralls.wear!
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start do
  # add_filter '/test/'
end
require 'minitest/autorun'
require 'minitest/hell'
require 'minitest/pride'

$LOAD_PATH.unshift(File.expand_path('../lib/', __dir__))
require File.expand_path('../lib/symbolmath.rb', __dir__)

def build(&block)
  SymbolMath::Expression.build(&block)
end

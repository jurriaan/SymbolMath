# SymbolMath

SymbolMath is a small math experiment using Ruby 2.0+

## Examples
```ruby
expression = SymbolMath::expr { a**2 + b**2 }
expression.fdiff(:a) # => (2 * <Symbol: a>)
expression.evaluate(a: 2, b: 5) # => 29

expression = SymbolMath::expr { sin(x) }
expression.taylor(:x, 5).to_s # => "((x / 1!) + (-(x ** 3) / 3!) + ((x ** 5) / 5!))"
```

## Installation

Add this line to your application's Gemfile:

    gem 'symbolmath'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install symbolmath

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it ( https://github.com/[my-github-username]/symbolmath/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

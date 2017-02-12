require_relative 'exchange_rate.rb'
require_relative 'constants.rb'
require_relative 'currency_unit.rb'
require_relative 'multi_currency.rb'


module ConverterMethods
  CURRENCIES.each do |cur|
    define_method cur do
      MultiCurrency.new([CurrencyUnit.new(self, cur)])
    end
  end
end

if RUBY_VERSION >= '2.4'
  Integer.include(ConverterMethods)
else
  Fixnum.include(ConverterMethods)
  Bignum.include(ConverterMethods)
end
Float.include(ConverterMethods)

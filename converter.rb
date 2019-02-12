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

# handle Fixnum => Integer migration in ruby 2.4
integer_class = 1.class
integer_class.include(ConverterMethods)

Float.include(ConverterMethods)

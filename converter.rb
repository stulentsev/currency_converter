require_relative 'exchange_rate.rb'
require_relative 'constants.rb'
require_relative 'currencyable.rb'
require_relative 'single_currency.rb'
require_relative 'multi_currency.rb'


module ConverterMethods
  CURRENCIES.each do |cur|
    define_method cur do
      SingleCurrency.new(self, cur)
    end
  end
end

Fixnum.include(ConverterMethods)
Float.include(ConverterMethods)

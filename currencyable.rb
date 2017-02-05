require_relative 'constants.rb'

module Currencyable
  def +(other)
    fail ArgumentError unless other.is_a?(Currencyable)

    if adding_will_convert_to_multi?(other)
      MultiCurrency.add_two(self, other)
    else
      self.class.new(number + other.number, currency)
    end
  end

  def compound?
    false
  end

  CURRENCIES.each do |target_currency|
    define_method "to_#{target_currency}" do
      require 'awesome_print'
      resulting_number = to_currency_list.reduce(0) do |conversion_result, (n, c)|
        rate = ExchangeRate.fetch_rate(c, target_currency)
        conversion_result + (n * rate).round(2)
      end

      SingleCurrency.new(resulting_number.round(2), target_currency)
    end
  end
end

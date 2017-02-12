class MultiCurrency
  attr_reader :single_currencies

  def initialize(single_currencies)
    @single_currencies = single_currencies
  end

  def ==(other)
    return false unless other.is_a?(MultiCurrency)

    single_currencies.sort == other.single_currencies.sort
  end

  def +(other)
    fail ArgumentError unless other.is_a?(MultiCurrency)

    increment_with(other)
  end

  # conversion methods
  CURRENCIES.each do |target_currency|
    define_method "to_#{target_currency}" do
      resulting_number = single_currencies.reduce(0) do |conversion_result, sc|
        n, c = sc.number, sc.currency
        rate = ExchangeRate.strategy.fetch_rate(c, target_currency)
        conversion_result + (n * rate).round(2)
      end

      MultiCurrency.new([CurrencyUnit.new(resulting_number.round(2), target_currency)])
    end
  end

  def inspect
    "(#{single_currencies.map(&:inspect).join(', ')})"
  end

  private

  def increment_with(other)
    other.single_currencies.each do |other_currency|
      single = single_currencies.detect { |sc| sc.currency == other_currency.currency }
      if single
        single.number += other_currency.number
      else
        single_currencies << CurrencyUnit.new(other_currency.number, other_currency.currency)
      end
    end

    self
  end

end

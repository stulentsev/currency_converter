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

end

class SingleCurrency
  include Currencyable

  attr_reader :currency
  attr_accessor :number

  def initialize(number, currency)
    @number   = number
    @currency = currency
  end

  def adding_will_convert_to_multi?(other)
    currency != other.currency
  end

  def ==(other)
    return false unless other.is_a?(SingleCurrency)
    currency == other.currency && number == other.number
  end

  def to_currency_list
    [[number, currency]]
  end

  def inspect
    "#{number} #{currency}"
  end
end

class MultiCurrency
  include Currencyable

  attr_reader :single_currencies

  def initialize(single_currencies)
    @single_currencies = single_currencies
  end

  def compound?
    true
  end

  def adding_will_convert_to_multi?(*)
    true
  end

  def ==(other)
    return false unless other.is_a?(Currencyable)

    to_currency_list == other.to_currency_list
  end

  def to_currency_list
    single_currencies.map(&:to_currency_list)
  end

  def increment_with(other)
    other.to_currency_list.each do |num, cur|
      single = single_currencies.detect{|sc| sc.currency == cur}
      if single
        single.number += num
      else
        single_currencies << SingleCurrency.new(num, cur)
      end
    end

    self
  end

  def inspect
    "(#{single_currencies.map(&:inspect).join(', ')})"
  end

  def self.add_two(one, other)
    if one.compound?
      one.increment_with(other)
    elsif other.compound?
      other.increment_with(one)
    else
      new([one, other])
    end
  end

end

module ConverterMethods
  [:usd, :eur, :rub].each do |cur|
    define_method cur do
      SingleCurrency.new(self, cur)
    end
  end
end

Fixnum.include(ConverterMethods)
Float.include(ConverterMethods)

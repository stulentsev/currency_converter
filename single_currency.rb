require_relative 'currencyable.rb'

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
    currency == other.currency && number.to_f == other.number.to_f
  end

  def to_currency_list
    [[number, currency]]
  end

  def inspect
    "#{number} #{currency}"
  end
end

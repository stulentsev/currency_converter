require_relative 'currencyable.rb'

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
    single_currencies.flat_map(&:to_currency_list)
  end

  def increment_with(other)
    other.to_currency_list.each do |num, cur|
      single = single_currencies.detect { |sc| sc.currency == cur }
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

class CurrencyUnit
  attr_reader :currency
  attr_accessor :number

  def initialize(number, currency)
    @number   = number
    @currency = currency
  end

  def inspect
    "#{number} #{currency}"
  end

  def ==(other)
    number == other.number && currency == other.currency
  end

  def <=>(other)
    currency <=> other.currency
  end
end

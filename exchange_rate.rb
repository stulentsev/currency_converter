class ExchangeRate
  def self.add_rate(cur_from, cur_to, rate)
    rates[[cur_from, cur_to]] = rate.to_f
    rates[[cur_to, cur_from]] = 1.0 / rate # reverse rate
  end

  def self.fetch_rate(cur_from, cur_to)
    rates[[cur_from, cur_to]] || fail("rate not found for #{cur_from}, #{cur_to}")
  end

  private

  def self.rates
    @rates ||= {}
  end
end

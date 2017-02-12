require 'minitest/autorun'
require './converter'

class ConverterTest < Minitest::Test
  def setup
    ExchangeRate.add_rate(:eur, :usd, 1.08)
    ExchangeRate.add_rate(:eur, :rub, 63.7)
    ExchangeRate.add_rate(:usd, :rub, 59.0)
  end

  def test_same_currency_math
    assert_equal 1.usd + 2.usd, 3.usd
    assert_equal 3.eur + 4.eur, 7.eur
    assert_equal 1.5.rub + 2.rub, 3.5.rub

    refute_equal 1.usd, 1.rub
    refute_equal 1.usd, 63.7.rub # even though it's the same amount of money
  end

  def test_compound_currency_math
    assert_equal 3.usd + 2.eur, 1.5.usd + 0.5.usd + 1.3.eur + 1.usd + 0.7.eur
  end

  def test_converter_method_existence
    assert_respond_to 1.usd, :to_usd
    assert_respond_to 1.usd, :to_eur
    assert_respond_to 1.usd, :to_rub
  end

  def test_simple_conversion
    assert_equal 100.eur.to_usd, 108.usd
    assert_equal 100.eur.to_rub, 6370.rub

    assert_equal 100.usd.to_rub, 5900.rub
    assert_equal 100.usd.to_eur, 92.59.eur
  end

  def test_compound_conversion
    assert_equal (100.eur + 100.usd).to_rub, 12270.rub
  end

end

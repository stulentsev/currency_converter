require 'minitest/autorun'
require './converter'

class ConverterTest < Minitest::Test
  def test_simple_value_converter
    assert_kind_of Currencyable, 1.usd
    assert_kind_of Currencyable, 1.eur
    assert_kind_of Currencyable, 1.rub
    assert_kind_of Currencyable, 1.1.usd
    assert_kind_of Currencyable, 1.2.eur
    assert_kind_of Currencyable, 1.3.rub
  end

  def test_compound_value_type
    assert_kind_of Currencyable, 1.usd + 2.usd
    assert_kind_of Currencyable, 1.usd + 2.rub
  end

  def test_same_currency_math
    assert_equal 1.usd + 2.usd, 3.usd
    assert_equal 3.eur + 4.eur, 7.eur
    assert_equal 1.5.rub + 2.rub, 3.5.rub
  end

  def test_compound_currency_math
    assert_equal 3.usd + 2.eur, 1.5.usd + 0.5.usd + 1.3.eur + 1.usd + 0.7.eur
  end
end

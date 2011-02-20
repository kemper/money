require 'test/unit'
require 'money'
require 'set'

class MoneyTest < Test::Unit::TestCase

  def test_objects_of_different_classes_should_not_be_equal
    money = Money.new "1"
    assert_not_equal nil, money
    assert_not_equal 1, money
    assert_not_equal "1", money
  end

  def test_money_objects_of_different_values_should_not_be_equal
    money = Money.new "1"
    assert_not_equal Money.new("2"), money
  end

  def test_money_objects_of_same_values_should_be_equal
    money = Money.new "1"
    assert_equal Money.new("1.0"), money
    assert_equal Money.new("1.00"), money
    assert_equal Money.new("1.00"), money
  end

  def test_money_identity_works_for_objects_that_rely_on_them
    money1, money2 = Money.new(5), Money.new(5)
    assert money1.eql? money2
    assert_equal money1.hash, money2.hash
    assert_equal 1, Set.new([money1, money2]).size
  end

  def test_should_round_to_nearest_cent
    money = Money.new "10.123"
    assert_equal Money.new("10.12"), money
  end

  def test_displaying_money_should_display_as_dollars
    money = Money.new "10.25"
    assert_equal "$10.25", money.to_s
  end

  def test_money_should_display_with_leading_zero_if_less_than_one_dollar
    money = Money.new ".25"
    assert_equal "$0.25", money.to_s
  end

  def test_money_can_be_created_with_numbers
    money = Money.new 5
    assert_equal Money.new("5"), money
  end

  def test_money_can_be_created_with_money_string
    money = Money.new "$5.0"
    assert_equal Money.new("5.0"), money
  end

  def test_money_creating_with_invalid_money_values_results_in_zero_money
    assert_raises(ArgumentError) { Money.new(nil) }
    assert_raises(ArgumentError) { Money.new("") }
    assert_raises(ArgumentError) { Money.new("asdf") }
    assert_raises(ArgumentError) { Money.new("5$.0") }
    assert_raises(ArgumentError) { Money.new("#5.0") }
    assert_raises(ArgumentError) { Money.new("5.0%") }
    assert_raises(ArgumentError) { Money.new("5.0x") }
    assert_raises(ArgumentError) { Money.new("0xA") }
  end

  def test_adding_money
    assert_equal Money.new("0"), Money.new("0") + Money.new("0")
    assert_equal Money.new("1"), Money.new("0") + Money.new("1")
    assert_equal Money.new(".50"), Money.new(".25") + Money.new(".25")
    assert_equal Money.new("7.07"), Money.new("5.05") + Money.new("2.02")
  end

  def test_adding_money_with_negative_values
    assert_equal Money.new("0"), Money.new("-0") + Money.new("0")
    assert_equal Money.new("-1"), Money.new("0") + Money.new("-1")
    assert_equal Money.new("0.0"), Money.new("-.25") + Money.new(".25")
    assert_equal Money.new("3.03"), Money.new("5.05") + Money.new("-2.02")
    assert_equal Money.new("-3.03"), Money.new("-1.01") + Money.new("-2.02")
  end

  def test_subtracting_money
    assert_equal Money.new("0"), Money.new("0") - Money.new("0")
    assert_equal Money.new("-1"), Money.new("0") - Money.new("1")
    assert_equal Money.new("0.0"), Money.new(".25") - Money.new(".25")
    assert_equal Money.new("3.03"), Money.new("5.05") - Money.new("2.02")
    assert_equal Money.new("-7.07"), Money.new("-5.05") - Money.new("2.02")
  end

  def test_comparing_money
    assert Money.new("2") > Money.new("1")
    assert Money.new("2") >= Money.new("2")
    assert Money.new("1") < Money.new("2")
    assert Money.new("1") <= Money.new("2")
  end

  def test_comparing_money_to_non_money_object_raises_argument_exception
    assert_raises ArgumentError do
      Money.new(1) < nil
    end
  end

  def test_adding_money_with_non_money_object_raises_argument_error
    assert_raises ArgumentError do
      Money.new(1) + nil
    end
  end

  def test_subtracting_money_with_non_money_object_raises_argument_error
    assert_raises ArgumentError do
      Money.new(1) - nil
    end
  end

end

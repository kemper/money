require 'bigdecimal'
require 'forwardable'

class Money
  include Comparable
  extend Forwardable
  attr_reader :value
  def_delegator :value, :hash

  def initialize value
    string_value = strip_dollar_sign value
    raise ArgumentError.new("creation of Money failed with #{value.inspect}") unless is_numeric?(string_value)
    @value = BigDecimal.new(string_value).round(2)
  end

  def <=>(other)
    value <=> other.value if self.class.equal?(other.class)
  end

  alias eql? ==

  def to_s
    "$#{value.to_s("F")}"
  end

  def +(other)
    raise ArgumentError.new("addition of Money with #{other.inspect} failed") unless self.class.equal?(other.class)
    Money.new(value + other.value)
  end

  def -(other)
    raise ArgumentError.new("subtraction of Money with #{other.inspect} failed") unless self.class.equal?(other.class)
    Money.new(value - other.value)
  end

  protected

  def strip_dollar_sign value
    value.to_s.start_with?("$") ? value.to_s.sub("$", "") : value.to_s
  end

  def is_numeric? value
    begin Float(value); true end rescue false
  end

end

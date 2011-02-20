require 'bigdecimal'
require 'forwardable'

class Money
  extend Forwardable
  attr_reader :value
  def_delegator :value, :hash

  def initialize value
    string_value = value.to_s.start_with?("$") ? value.to_s.sub("$", "") : value.to_s
    string_value = "0" unless is_numeric?(string_value)
    @value = BigDecimal.new(string_value).round(2)
  end

  def to_s
    "$#{value.to_s("F")}"
  end

  def eql? other
    self.class.equal?(other.class) && value.eql?(other.value)
  end

  alias == eql?

  def +(other)
    Money.new(value + other.value)
  end

  def -(other)
    Money.new(value - other.value)
  end

  protected

  def is_numeric? value
    begin Float(value); true end rescue false
  end

end

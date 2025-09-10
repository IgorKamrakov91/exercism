class SimpleCalculator
  class UnsupportedOperation < StandardError
  end

  ALLOWED_OPERATIONS = ['+', '/', '*'].freeze

  def self.calculate(first_operand, second_operand, operation)
    raise ArgumentError unless first_operand.is_a?(Numeric)
    raise ArgumentError unless second_operand.is_a?(Numeric)

    raise UnsupportedOperation unless ALLOWED_OPERATIONS.include?(operation)

    return "Division by zero is not allowed." if second_operand == 0 and operation == '/'

    result = case operation
    when '+'
      first_operand + second_operand
    when '/'
      first_operand / second_operand
    when '*'
      first_operand * second_operand
    end

    "#{first_operand} #{operation} #{second_operand} = #{result}"
  end
end

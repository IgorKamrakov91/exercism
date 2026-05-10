module CollatzConjecture
  def self.steps(number, number_of_steps = 0)
    raise ArgumentError if number.zero? || number.negative?

    return number_of_steps if number == 1

    number_of_steps += 1
    if number.odd?
      steps(number * 3 + 1, number_of_steps)
    elsif number.even?
      steps(number / 2, number_of_steps)
    else
      number_of_steps
    end
  end
end

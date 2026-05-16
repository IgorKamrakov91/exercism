class Sieve
  def initialize(top)
    @top = top
  end

  def primes
    numbers = [nil, nil, *2..@top]

    (2..Math.sqrt(@top)).each do |i|
      (i**2..@top).step(i) { |m| numbers[m] = nil } if numbers[i]
    end

    numbers.compact
  end
end

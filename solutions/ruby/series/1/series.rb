class Series
  def initialize(string)
    raise ArgumentError if string.empty?

    @series = string
  end

  def slices(number)
    raise ArgumentError if number <= 0
    raise ArgumentError if number > @series.length

    (0..@series.length - number).map { |i| @series[i, number] }
  end
end

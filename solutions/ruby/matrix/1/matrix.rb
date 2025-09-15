class Matrix
  def initialize(matrix)
    @rows = matrix.split("\n").map { |row| row.split.map(&:to_i) }
  end

  def row(number)
    @rows[number - 1]
  end

  def column(number)
    @rows.map { |row| row[number - 1] }
  end
end

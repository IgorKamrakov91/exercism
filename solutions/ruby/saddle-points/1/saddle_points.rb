class Grid
  def self.saddle_points(matrix)
    return [] if matrix.empty?

    row_maxima = {}
    col_minima = {}

    # Find maximum for each row
    matrix.each_with_index do |row, row_idx|
      row_maxima[row_idx] = row.max
    end

    # Find minima for each col
    (0..matrix[0].length).each do |col_idx|
      values_in_col = []
      matrix.each do |row|
        values_in_col << row[col_idx]
      end

      col_minima[col_idx] = values_in_col.min
    end

    saddle_points = []

    matrix.each_with_index do |row, row_idx|
      row.each_with_index do |value, col_idx|
        if row_maxima[row_idx] == value && col_minima[col_idx] == value
          saddle_points << { 'row' => row_idx + 1, 'column' => col_idx + 1 }
        end
      end
    end

    saddle_points
  end
end

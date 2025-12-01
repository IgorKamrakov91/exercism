# frozen_string_literal: true

# Write your code for the 'Transpose' exercise in this file. Make the tests in
# `transpose_test.rb` pass.
#
# To get started with TDD, see the `README.md` file in your
# `ruby/transpose` directory.
class Transpose
  def self.transpose(input)
    lines = input.split("\n")

    max_width = lines.map(&:length).max

    lines.map { |line| line.ljust(max_width, "\0") }
         .map(&:chars)
         .transpose
         .map(&:join)
         .join("\n")
         .gsub(/\0+$/, '')
         .gsub(/\0/, ' ')
  end
end

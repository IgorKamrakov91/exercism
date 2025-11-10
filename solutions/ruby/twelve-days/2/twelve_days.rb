=begin
Write your code for the 'Twelve Days' exercise in this file. Make the tests in
`twelve_days_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/twelve-days` directory.
=end

GIFTS = [
  "a Partridge in a Pear Tree.\n",
  "two Turtle Doves, and ",
  "three French Hens, ",
  "four Calling Birds, ",
  "five Gold Rings, ",
  "six Geese-a-Laying, ",
  "seven Swans-a-Swimming, ",
  "eight Maids-a-Milking, ",
  "nine Ladies Dancing, ",
  "ten Lords-a-Leaping, ",
  "eleven Pipers Piping, ",
  "twelve Drummers Drumming, "
].freeze

DAYS = [
  "first",
  "second",
  "third",
  "fourth",
  "fifth",
  "sixth",
  "seventh",
  "eighth",
  "ninth",
  "tenth",
  "eleventh",
  "twelfth"
].freeze

class TwelveDays
  def self.song
    output = String.new
    DAYS.each_with_index do |day, i|
      verse = verse_builder(GIFTS[0..i])
      line = "On the #{day} day of Christmas my true love gave to me: #{verse}\n"
      output += line
    end
    output.chomp("\n")
  end

  def self.verse_builder(string_array)
    verse = String.new
    countdown = string_array.reverse
    countdown.each do |string|
      verse += string
    end

    verse
  end
end

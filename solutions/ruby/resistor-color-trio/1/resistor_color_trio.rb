class ResistorColorTrio
  COLORS_VALUES = %w[
    black
    brown
    red
    orange
    yellow
    green
    blue
    violet
    grey
    white
  ].freeze

  UNITS = %w[ohms kiloohms megaohms gigaohms].freeze

  attr_reader :colors

  def initialize(colors)
    @colors = colors
  end

  def label
    raise ArgumentError unless colors.all? { |color| COLORS_VALUES.include?(color) }

    resistance = first_two_colors * 10**third_color
    unit_index = 0

    while resistance >= 1000 && (resistance % 1000).zero? && unit_index < UNITS.length - 1
      resistance /= 1000
      unit_index += 1
    end

    "Resistor value: #{resistance} #{UNITS[unit_index]}"
  end

  def first_two_colors
    colors.take(2).map do |color|
      value(color)
    end.join.to_i
  end

  def third_color
    value(colors[2])
  end

  def value(index)
    COLORS_VALUES.index(index)
  end
end

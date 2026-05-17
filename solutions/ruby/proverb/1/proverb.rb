class Proverb
  attr_reader :words, :qualifier

  def initialize(*words, qualifier: nil)
    @words = words
    @qualifier = qualifier
  end

  def to_s
    return '' if @words.empty?

    lines = words.each_cons(2).map do |want, lost|
      "For want of a #{want} the #{lost} was lost."
    end

    qualifier_text = qualifier ? "#{qualifier} " : ''
    lines << "And all for the want of a #{qualifier_text}#{words[0]}."

    lines.join("\n")
  end
end

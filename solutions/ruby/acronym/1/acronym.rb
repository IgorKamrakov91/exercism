module Acronym
  def self.abbreviate(string)
    string.split(/[\s\-_]+/)
          .reject(&:empty?)
          .map { |word| word.gsub(/[^a-zA-Z]/, '')[0]&.upcase }
          .compact
          .join
  end
end

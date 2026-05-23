class ParallelLetterFrequency
  def self.count(texts)
    ret_val = Hash.new(0)
    return ret_val if texts.empty?

    threads = texts.map do |text|
      Thread.new do
        format_text = text.downcase.gsub(/[^\p{L}a-z]/, '')
        format_text.each_char { |char| ret_val[char] += 1 }
      end
    end

    threads.each(&:join)

    ret_val
  end
end

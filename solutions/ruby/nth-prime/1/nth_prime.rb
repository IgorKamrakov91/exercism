require 'prime'

class Prime
  def self.nth(count)
    raise ArgumentError if count < 1

    Prime.first(count).last
  end
end

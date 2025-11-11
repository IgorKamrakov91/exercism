# Write your code for the 'Tournament' exercise in this file. Make the tests in
# `tournament_test.rb` pass.
#
# To get started with TDD, see the `README.md` file in your
# `ruby/tournament` directory.

class Tournament
  HEADER = 'Team                           | MP |  W |  D |  L |  P'
  ROW_FORMAT = '%-30s | %2d | %2d | %2d | %2d | %2d'

  def self.tally(input)
    team_stats = Hash.new { |hash, team_name| hash[team_name] = default_stats }

    input.to_s.each_line do |line|
      team1, team2, result = parse_line(line)
      next if team1.nil? || team2.nil? || result.nil?

      case result
      when 'win'
        apply_result(team_stats[team1], :win)
        apply_result(team_stats[team2], :loss)
      when 'loss'
        apply_result(team_stats[team1], :loss)
        apply_result(team_stats[team2], :win)
      when 'draw'
        apply_result(team_stats[team1], :draw)
        apply_result(team_stats[team2], :draw)
      end
    end

    lines = [HEADER]
    sorted = team_stats.sort_by { |name, stats| [-stats[:points], name] }
    sorted.each do |name, stats|
      lines << format(ROW_FORMAT, name, stats[:matches], stats[:wins], stats[:draws], stats[:losses], stats[:points])
    end
    lines.join("\n") + "\n"
  end

  class << self
    private

    def default_stats
      { matches: 0, wins: 0, draws: 0, losses: 0, points: 0 }
    end

    def parse_line(line)
      trimmed = line.to_s.strip
      return [nil, nil, nil] if trimmed.empty?

      parts = trimmed.split(';')
      return [nil, nil, nil] unless parts.size == 3

      parts
    end

    def apply_result(stats, result)
      stats[:matches] += 1
      case result
      when :win
        stats[:wins] += 1
        stats[:points] += 3
      when :draw
        stats[:draws] += 1
        stats[:points] += 1
      when :loss
        stats[:losses] += 1
      end
    end
  end
end

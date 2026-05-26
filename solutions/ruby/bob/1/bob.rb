class Bob
  RESPONSES = {
    shouting: 'Whoa, chill out!',
    question: 'Sure.',
    shouted_question: "Calm down, I know what I'm doing!",
    silent: 'Fine. Be that way!',
    default: 'Whatever.'
  }.freeze

  def self.hey(message)
    msg = message.strip

    if shouting?(msg) && question?(msg)
      respond :shouted_question
    elsif shouting?(msg)
      respond :shouting
    elsif question?(msg)
      respond :question
    elsif silent?(msg)
      respond :silent
    else
      respond :default
    end
  end

  def self.shouting?(message)
    message == message.upcase && message.match(/[a-zA-Z]/)
  end

  def self.question?(message)
    message.end_with?('?')
  end

  def self.silent?(message)
    message.split.join('').empty?
  end

  def self.respond(response)
    RESPONSES[response]
  end

  private_class_method :respond
end

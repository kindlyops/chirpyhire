class Broadcaster::Part
  def self.broadcast(part)
    new(part).broadcast
  end

  def initialize(part)
    @part = part
  end

  def broadcast
    PartsChannel.broadcast_to(conversation, part_hash)
  end

  private

  attr_reader :part

  delegate :conversation, to: :part

  def part_hash
    string = part_string
    JSON.parse(string)
  end

  def part_string
    ApplicationController.render partial: 'parts/part', locals: {
      part: part
    }
  end
end

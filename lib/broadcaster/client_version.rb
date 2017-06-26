class Broadcaster::ClientVersion
  def self.broadcast(version)
    new(version).broadcast
  end

  def initialize(version)
    @version = version
  end

  def broadcast
    ActionCable.server.broadcast('application', version)
  end

  private

  attr_reader :version
end

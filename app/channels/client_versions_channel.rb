class ClientVersionsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'application'
  end
end

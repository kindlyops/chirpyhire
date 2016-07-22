class Threader
  def self.thread
    User.find_each do |user|
      messages = user.messages.by_recency

      messages.each_with_index do |message, index|
        message.update!(parent_id: messages[index + 1].try!(:id))
      end
    end
  end
end

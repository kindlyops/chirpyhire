Message.where(user_id: nil).find_in_batches do |messages|
  messages.each {|message| message.update(user_id: message.messageable.user_id) }
end

Notification.where(message_id: nil).find_in_batches do |notifications|
  notifications.each {|notification| notification.update(message_id: notification.message.id) }
end

Answer.where(message_id: nil).find_in_batches do |answers|
  answers.each {|answer| answer.update(message_id: answer.message.id) }
end

Inquiry.where(message_id: nil).find_in_batches do |inquiries|
  inquiries.each {|inquiry| inquiry.update(message_id: inquiry.message.id) }
end

Chirp.where(message_id: nil).find_in_batches do |chirps|
  chirps.each {|chirp| chirp.update(message_id: chirp.message.id) }
end

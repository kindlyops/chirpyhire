json.greeting do
  json.id bot.greeting.id
  json.body bot.greeting.body
end

json.questions bot.ranked_questions do |question|
  json.id question.id
  json.bot_id question.bot_id
  json.body question.body(formatted: false)
  json.answers question.answers
  json.active question.active
end

json.goals bot.goals do |goal|
  json.id goal.id
  json.body goal.body
end

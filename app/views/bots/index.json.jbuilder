json.array! @bots do |bot|
  json.id bot.id
  json.greeting do
    json.id bot.greeting.id
    json.body bot.greeting.body
  end

  json.questions bot.questions do |question|
    json.id question.id
    json.body question.body(formatted: false)
    json.answers question.answers
    json.active question.active
  end

  json.goals bot.goals do |goal|
    json.id goal.id
    json.body goal.body
  end
end

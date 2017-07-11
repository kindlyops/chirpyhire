json.id @bot.id
json.name @bot.name

json.greeting do
  json.id @bot.greeting.id
  json.body @bot.greeting.body
end

json.questions @bot.ranked_questions do |question|
  json.id question.id
  json.bot_id question.bot_id
  json.body question.body(formatted: false)
  json.answers question.answers
  json.active question.active
  json.follow_ups question.follow_ups do |follow_up|
    json.id follow_up.id
    json.question_id follow_up.question_id
    json.body follow_up.body
    json.action follow_up.action
    json.humanized_action follow_up.humanized_action
    json.type follow_up.type
    json.rank follow_up.rank
    json.next_question_id follow_up.next_question_id
    json.goal_id follow_up.goal_id
    json.response follow_up.response
    json.tags follow_up.tags do |tag|
      json.id tag.id
      json.name tag.name
    end
  end
end

json.goals @bot.goals do |goal|
  json.id goal.id
  json.body goal.body

  json.tags goal.tags do |tag|
    json.id tag.id
    json.name tag.name
  end
end

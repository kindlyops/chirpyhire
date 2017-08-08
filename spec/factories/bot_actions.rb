FactoryGirl.define do
  factory :bot_action do
    bot
    type { 'NextQuestionAction' }
  end

  factory :question_action, parent: :bot_action, class: 'QuestionAction' do
    bot
    question
    type { 'QuestionAction' }
  end

  factory :goal_action, parent: :bot_action, class: 'GoalAction' do
    bot
    goal
    type { 'GoalAction' }
  end
end

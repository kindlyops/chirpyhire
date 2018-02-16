namespace :sweep do
  desc 'Sweep For Ended Free Trials'
  task trials: [:environment] do
    SubscriptionSweeper.call
  end

  desc 'Sweep For Interview Reminders'
  task reminders: [:environment] do
    Reminder::Sweeper.call
  end
end

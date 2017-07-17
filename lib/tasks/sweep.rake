namespace :sweep do
  desc 'Sweep For Ended Free Trials'
  task trials: [:environment] do
    SubscriptionSweeper.call
  end
end

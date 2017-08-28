namespace :metric do
  desc 'Monthly Active Users'
  task mau: [:environment] do
    Internal::Metric::Mau.call
  end

  desc 'Weekly Active Users'
  task wau: [:environment] do
    Internal::Metric::Wau.call
  end

  task health: [:environment] do
    Internal::Report::Health.call
  end
end

namespace :metric do
  desc "Monthly Active Users"
  task mau: [:environment] do
    Internal::Metric::Mau.call
  end
end

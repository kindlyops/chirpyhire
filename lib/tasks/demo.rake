namespace :demo do
  desc 'Reset Demo Env'
  task reset: [:environment] do
    Demo::Reset.call if Rails.env.demo?
  end
end

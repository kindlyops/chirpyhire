namespace :reporter do
  desc 'Send Daily Email'
  task daily: [:environment] do
    Reporter::Daily.call
  end
end

namespace :candidates do
  desc "Back populates any old candidates that don't have anonymous nicknames"
  task :back_populate_nicknames => :environment do
    puts 'Updating candidates...' 
    Candidate.find_each do |candidate|
      next if candidate.nickname.present?
      nickname = Nicknames::Generator.new(candidate).generate
      puts "Updating candidate #{candidate.id}... to have name #{nickname}"
      candidate.update!(nickname: nickname)
    end
  end
end

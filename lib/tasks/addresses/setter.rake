namespace :addresses do
  desc "Creates csv report of potential address changes. Pass update=true to make the change."
  task :setter, [:update] => [:environment] do |task, args|
    if args.update
      puts "update=true passed"
      puts "starting in 5 seconds"
      sleep(1)
      puts "starting in 4 seconds"
      sleep(1)
      puts "starting in 3 seconds"
      sleep(1)
      puts "starting in 2 seconds"
      sleep(1)
      puts "starting in 1 seconds"
      sleep(1)

      Candidate.find_each.with_index do |candidate, index|
        puts "#{index} - Candidate: #{candidate.id} starting"
        output = AddressSetter.new(candidate).call
        puts "#{index} - Candidate: #{candidate.id} #{output}"
        puts "sleeping 1"
        sleep(1)
      end
    else
      puts "update=false csv dry run"
      puts "starting in 5 seconds"
      sleep(1)
      puts "starting in 4 seconds"
      sleep(1)
      puts "starting in 3 seconds"
      sleep(1)
      puts "starting in 2 seconds"
      sleep(1)
      puts "starting in 1 seconds"
      sleep(1)

      result = CSV.generate do |csv|
        csv << ["message_id", "message_body", "current_address", "new_address", "candidate_feature_id", "latitude", "longitude", "postal_code", "country", "city"]

        Candidate.find_each.with_index do |candidate, index|
          puts "#{index} - Candidate: #{candidate.id} starting"
          output = AddressSetter.new(candidate, csv: csv).call
          puts "#{index} - Candidate: #{candidate.id} #{output}"
          puts "sleeping 1"
          sleep(1)
        end
      end

      puts result
    end
  end
end

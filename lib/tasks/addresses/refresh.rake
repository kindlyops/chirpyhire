namespace :addresses do
  desc 'Creates csv report of potential address changes. Pass update=true to make the change.'
  task :refresh, [:update] => [:environment] do |_task, args|
    if args.update
      puts 'update=true passed'
      puts 'starting in 5 seconds'
      sleep(1)
      puts 'starting in 4 seconds'
      sleep(1)
      puts 'starting in 3 seconds'
      sleep(1)
      puts 'starting in 2 seconds'
      sleep(1)
      puts 'starting in 1 seconds'
      sleep(1)

      Message.find_each.with_index do |message, index|
        puts "#{index} - Message: #{message.id} starting"
        output = AddressRefresher.new(message).call
        puts "#{index} - Message: #{message.id} #{output}"
        puts 'sleeping 1'
        sleep(1)
      end
    else
      puts 'update=false csv dry run'
      puts 'starting in 5 seconds'
      sleep(1)
      puts 'starting in 4 seconds'
      sleep(1)
      puts 'starting in 3 seconds'
      sleep(1)
      puts 'starting in 2 seconds'
      sleep(1)
      puts 'starting in 1 seconds'
      sleep(1)

      result = CSV.generate do |csv|
        csv << %w(message_id message_body current_address new_address candidate_feature_id latitude longitude postal_code country city)

        Message.find_each.with_index do |message, index|
          puts "#{index} - Message: #{message.id} starting"
          output = AddressRefresher.new(message, csv: csv).call
          puts "#{index} - Message: #{message.id} #{output}"
          puts 'sleeping 1'
          sleep(1)
        end
      end

      puts result
    end
  end
end

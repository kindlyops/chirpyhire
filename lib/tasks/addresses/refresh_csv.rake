namespace :addresses do
  desc "Generates a CSV of potential address updates"
  task refresh_csv: :environment do
    result = CSV.generate do |csv|
      csv << ["message_id", "message_body", "current_address", "new_address", "candidate_feature_id", "latitude", "longitude", "postal_code", "country", "city"]

      Message.find_each.with_index do |message, index|
        puts "#{index} - Message: #{message.id} starting"
        output = AddressRefresher.new(message, csv).call
        puts "#{index} - Message: #{message.id} #{output}"
        puts "sleeping 1"
        sleep(1)
      end
    end

    puts result
  end
end


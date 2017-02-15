namespace :candidates do
  desc "Exports Candidates For an Organization"
  task :export, [:organization_id] => :environment do |t, args|
    attributes = ["ID",
                  "First Name",
                  "Last Name",
                  "Phone",
                  "Stage",
                  "Zipcode",
                  "Availability",
                  "Transportation",
                  "Experience",
                  "Certification",
                  "CPR / 1st Aid",
                  "Skin Test",
                  "Messages"]

    result = CSV.generate(headers: true) do |csv|
      csv << attributes

      organization = Organization.find(args[:organization_id])

      organization.candidates.find_each do |candidate|
        messages = candidate.messages.pluck(:body)
        url = "https://app.chirpyhire.com/users/#{candidate.user.id}/messages"
        candidate_attributes = [candidate.id,
          nil,
          nil,
          candidate.phone_number,
          candidate.stage.to_s,
          candidate.zipcode,
          candidate.availability,
          candidate.transportation,
          candidate.experience,
          candidate.certification,
          candidate.cpr,
          candidate.skin_test,
          url]

        csv << candidate_attributes.concat(messages)
      end
    end

    puts result
  end
end

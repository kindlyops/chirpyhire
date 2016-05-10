require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:body) { Faker::Lorem.word }
  let(:media_url) { Faker::Internet.url }

  let(:message) { create(:message, properties: {"Body" => body, "MediaUrl0" => media_url })}

  describe "#body" do
    it "is the body" do
      expect(message.body).to eq(body)
    end
  end

  describe "#media_urls" do
    it "is the media_urls" do
      expect(message.media_urls).to include(media_url)
    end
  end
end

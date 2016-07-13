require 'rails_helper'

RSpec.describe AddressRefresher do
  let(:message) { create(:message) }
  let(:csv) { CSV.new("") }
  let(:refresher) { AddressRefresher.new(message, csv: csv) }

  describe "#call" do
    context "message has an address" do
      context "with a candidate", vcr: { cassette_name: "AddressFinder-valid-address" } do
        let!(:candidate) { create(:candidate, user: message.user) }
        let(:message) { create(:message, body: "4059 Mt Lee Dr 90068") }

        it "returns an array of results" do
          expect(refresher.call).to include(message.id, message.body)
        end

        it "appends a row to the csv object" do
          expect(csv).to receive(:<<)
          refresher.call
        end

        context "with an existing address" do
          let!(:address_feature) { create(:candidate_feature, :address, candidate: candidate, id: 10293) }

          it "returns an array of results with the feature id" do
            expect(refresher.call).to include(address_feature.id, address_feature.properties['address'])
          end
        end
      end

      context "without a candidate" do
        it "returns no address found" do
          expect(refresher.call).to eq("No address found")
        end
      end
    end

    context "message does not have an address" do
      it "returns no address found" do
        expect(refresher.call).to eq("No address found")
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Document, type: :model do
  describe ".extract" do
    let(:document_path) { "/example/path" }
    let(:document) { OpenStruct.new(uri: "#{document_path}.json" )}
    let(:message) { create(:message) }

    let(:document_hash) do
      {
        url0: "#{Document::URI_BASE}#{document_path}"
      }
    end

    before(:each) do
      allow(message).to receive(:images).and_return([document])
    end

    it "returns an address hash" do
      expect(Document.extract(message)).to eq(document_hash)
    end
  end
end

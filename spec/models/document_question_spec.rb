require 'rails_helper'

RSpec.describe DocumentQuestion, type: :model do
  describe ".extract" do
    let(:document_path) { "/example/path" }
    let(:document) { OpenStruct.new(uri: "#{document_path}.json" )}
    let(:message) { create(:message) }

    let(:document_hash) do
      {
        url0: "#{DocumentQuestion::URI_BASE}#{document_path}",
        child_class: "document"
      }
    end

    before(:each) do
      allow(message).to receive(:images).and_return([document])
    end

    it "returns an document hash" do
      expect(DocumentQuestion.extract(message, double(question: double()))).to eq(document_hash)
    end
  end
end

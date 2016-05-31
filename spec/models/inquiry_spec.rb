require 'rails_helper'

RSpec.describe Inquiry, type: :model do

  describe "#expects?" do
    context "feature expects document" do
      let(:inquiry) { create(:inquiry) }

      context "message has media" do
        let(:answer) { build(:answer, message: create(:message, :with_image)) }

        it "is true" do
          expect(inquiry.expects?(answer)).to eq(true)
        end
      end

      context "message does not have media" do
        let(:answer) { build(:answer) }

        it "is false" do
          expect(inquiry.expects?(answer)).to eq(false)
        end
      end
    end
  end
end

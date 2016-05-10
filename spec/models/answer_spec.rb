require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe "#expected_format" do
    let(:answer) { build(:answer) }
    context "inquiry does not expect the answer's message format" do
      it "adds an inquiry error to the answer" do
        answer.valid?
        expect(answer.errors).to include(:inquiry)
      end
    end
  end
end

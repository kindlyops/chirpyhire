require 'rails_helper'

RSpec.describe OptInConstraint do

  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { OptInConstraint.new }

  before(:each) do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe "#matches?" do
    context "CARE as body" do
      let(:parameters) { { "body" => "CARE" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "care as body" do
      let(:parameters) { { "body" => "care" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "CARE in body" do
      context "with whitespace" do
        let(:parameters) { { "body" => "    CARE " } }

        it "is true" do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context "with additional text" do
        let(:parameters) { { "body" => "CARE to do the limbo?" } }

        it "is false" do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context "CARE not in body" do
      let(:parameters) { { "body" => "Another body" } }

      it "is false" do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end

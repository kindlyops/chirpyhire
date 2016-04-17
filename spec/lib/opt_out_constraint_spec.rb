require 'rails_helper'

RSpec.describe OptOutConstraint do

  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { OptOutConstraint.new }

  before(:each) do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe "#matches?" do
    context "STOP as body" do
      let(:parameters) { { "body" => "STOP" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "STOPALL as body" do
      let(:parameters) { { "body" => "STOPALL" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "QUIT as body" do
      let(:parameters) { { "body" => "QUIT" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "END as body" do
      let(:parameters) { { "body" => "END" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "UNSUBSCRIBE as body" do
      let(:parameters) { { "body" => "UNSUBSCRIBE" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "CANCEL as body" do
      let(:parameters) { { "body" => "CANCEL" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "stop as body" do
      let(:parameters) { { "body" => "stop" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "STOP in body" do
      context "with whitespace" do
        let(:parameters) { { "body" => "    STOP " } }

        it "is true" do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context "with additional text" do
        let(:parameters) { { "body" => "STOP to do the limbo?" } }

        it "is false" do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context "STOP not in body" do
      let(:parameters) { { "body" => "Another body" } }

      it "is false" do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Constraint::Answer do

  let(:request) { ActionDispatch::Request.new({}) }
  let(:constraint) { Constraint::Answer.new }

  before(:each) do
    allow(request).to receive(:request_parameters).and_return(parameters)
  end

  describe "#matches?" do
    context "Y as body" do
      let(:parameters) { { "Body" => "Y" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "y as body" do
      let(:parameters) { { "Body" => "y" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "N as body" do
      let(:parameters) { { "Body" => "N" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "n as body" do
      let(:parameters) { { "Body" => "n" } }
      it "is true" do
        expect(constraint.matches?(request)).to eq(true)
      end
    end

    context "answer in body" do
      context "with whitespace" do
        let(:parameters) { { "Body" => "    Y " } }

        it "is true" do
          expect(constraint.matches?(request)).to eq(true)
        end
      end

      context "with additional text" do
        let(:parameters) { { "Body" => "Y to do the limbo?" } }

        it "is false" do
          expect(constraint.matches?(request)).to eq(false)
        end
      end
    end

    context "answer not in body" do
      let(:parameters) { { "Body" => "Another body" } }

      it "is false" do
        expect(constraint.matches?(request)).to eq(false)
      end
    end
  end
end

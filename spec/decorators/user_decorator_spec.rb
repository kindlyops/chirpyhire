require 'rails_helper'

RSpec.describe UserDecorator do
  let(:model) { create(:user, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name) }
  let(:user) { UserDecorator.new(model) }

  describe "#name" do
    it "returns the first and last name" do
      expect(user.name).to eq("#{model.first_name} #{model.last_name}")
    end
  end

  describe "#phone_number" do
    context "without a phone number" do
      let(:model) { create(:user, phone_number: nil) }

      it "is an empty string" do
        expect(user.phone_number).to eq("")
      end
    end

    it "is the phone number" do
      expect(user.phone_number).to eq(model.phone_number.phony_formatted)
    end
  end
end

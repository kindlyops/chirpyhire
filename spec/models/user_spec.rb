require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "#name" do
    it "returns the first and last name" do
      expect(user.name).to eq("#{user.first_name} #{user.last_name}")
    end
  end

  describe "#phone_number" do
    context "without a phone number" do
      before(:each) do
        user.update(phone_number: nil)
      end

      it "is an empty string" do
        expect(user.phone_number).to eq("")
      end
    end
  end
end

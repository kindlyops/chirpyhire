require 'rails_helper'

RSpec.describe UserDecorator do
  let(:model) { create(:user) }
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
      expect(user.phone_number).to eq(model.phone_number)
    end
  end

  describe "#from" do
    it "is the user's name" do
      expect(user.from).to eq(user.name)
    end

    context "without a name" do
      let(:model) { create(:user, first_name: nil, last_name: nil) }

      it "is the user's phone_number" do
        expect(user.from).to eq(user.phone_number)
      end

      context "without a phone_number" do
        let(:model) { create(:user, phone_number:nil, first_name: nil, last_name: nil) }
        it "is an empty string" do
          expect(user.from).to eq("")
        end
      end
    end
  end

  describe "#to" do
    it "is the user's name" do
      expect(user.to).to eq(user.name)
    end

    context "without a name" do
      let(:model) { create(:user, first_name: nil, last_name: nil) }

      it "is the user's phone_number" do
        expect(user.to).to eq(user.phone_number)
      end

      context "without a phone_number" do
        let(:model) { create(:user, phone_number:nil, first_name: nil, last_name: nil) }
        it "is an empty string" do
          expect(user.to).to eq("")
        end
      end
    end
  end

  describe "#from_short" do
    context "with a first name" do
      it "is the first name" do
        expect(user.from_short).to eq(user.first_name)
      end
    end

    context "without a first name" do
      let(:model) { create(:user, first_name: nil) }

      it "is the phone number" do
        expect(user.from_short).to eq(user.phone_number)
      end

      context "without a phone number" do
        let(:model) { create(:user, first_name: nil, phone_number: nil) }

        it "is an empty string" do
          expect(user.from_short).to eq("")
        end
      end
    end
  end

  describe "#icon_class" do
    it "is fa-user" do
      expect(user.icon_class).to eq("fa-user")
    end
  end
end

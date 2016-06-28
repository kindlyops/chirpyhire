require 'rails_helper'

RSpec.describe OrganizationDecorator do
  let(:model) { create(:organization) }
  let(:organization) { OrganizationDecorator.new(model) }

  describe "#to" do
    it "is the organization's name" do
      expect(organization.to).to eq(organization.name)
    end
  end

  describe "#to_short" do
    it "is the organization's name" do
      expect(organization.to).to eq(organization.name)
    end
  end

  describe "#from" do
    it "is the organization's name" do
      expect(organization.to).to eq(organization.name)
    end
  end

  describe "#from_short" do
    it "is the organization's name" do
      expect(organization.to).to eq(organization.name)
    end
  end

  describe "#icon_class" do
    it "is fa-home" do
      expect(organization.icon_class).to eq("fa-home")
    end
  end
end

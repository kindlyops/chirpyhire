require 'rails_helper'

RSpec.describe Renderer do
  let(:user) { create(:user) }
  let(:organization) { user.organization }
  let(:template) { create(:template, body: "{{organization.name}}{{recipient.first_name}}") }

  describe "#call" do
    context "with template tags" do
      it "replaces the template tags appropriately" do
        expect(Renderer.call(template, user)).to eq("#{organization.name}#{user.first_name}")
      end
    end

    context "with a malicious template" do
      let(:template) { create(:template, body: "{{organization.destroy}}{{recipient.destroy}}") }

      it "raises an error" do
        expect {
          Renderer.call(template, user)
        }.to raise_error(NoMethodError)
      end

      it "does not destroy the organization" do
        expect {
          expect {
            Renderer.call(template, user)
          }.not_to change{Organization.count}
        }.to raise_error(NoMethodError)
      end

      it "does not destroy the user" do
        expect {
          expect {
            Renderer.call(template, user)
          }.not_to change{User.count}
        }.to raise_error(NoMethodError)
      end
    end
  end
end

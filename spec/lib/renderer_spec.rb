require 'rails_helper'

RSpec.describe Renderer do
  let(:candidate) { create(:candidate) }
  let(:organization) { candidate.organization }
  let(:template) { create(:template, body: "{{organization.name}}{{recipient.first_name}}") }

  describe "#call" do
    context "with template tags" do
      it "replaces the template tags appropriately" do
        expect(Renderer.call(template, candidate)).to eq("#{organization.name}#{candidate.first_name}")
      end
    end
  end
end

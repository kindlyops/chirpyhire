require 'rails_helper'

RSpec.describe Messaging::Response do
  let(:organization) { create(:organization) }

  subject { Messaging::Response.new(organization: organization) }
  describe "#error" do
    it "includes a friendly error message" do
      expect(subject.error).to include("Sorry I didn't understand that.")
    end
  end
end

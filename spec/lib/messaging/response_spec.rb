require 'rails_helper'

RSpec.describe Messaging::Response do
  let(:candidate) { create(:candidate) }

  subject { Messaging::Response.new(subject: candidate) }
  describe "#error" do
    it "includes a friendly error message" do
      expect(subject.error).to include("Sorry I didn't understand that.")
    end
  end
end

require 'rails_helper'

RSpec.describe Inquiry, type: :model do
  let(:organization) { create(:organization, :with_owner) }
  let(:inquiry) { create(:inquiry, candidate: create(:candidate, organization: organization)) }

  describe "#body" do
    let(:candidate) { create(:candidate) }
    context "with prelude flag" do
      it "includes the prelude" do
        expect(inquiry.body(prelude: true)).to include("We have a new client \
and want to see if you might be a good fit.")
      end
    end

    context "without prelude flag" do
      it "does not include the prelude" do
        expect(inquiry.body).not_to include("We have a new client \
and want to see if you might be a good fit.")
      end
    end

    it "includes the question body" do
      expect(inquiry.body).to include(inquiry.body)
    end

    it "includes the preamble" do
      expect(inquiry.body).to include("Reply Y or N.")
    end
  end
end

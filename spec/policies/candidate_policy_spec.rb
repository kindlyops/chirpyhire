require 'rails_helper'

RSpec.describe CandidatePolicy do
  subject { CandidatePolicy.new(account, candidate) }

  let(:candidate) { create(:candidate) }

  let(:resolved_scope) { CandidatePolicy::Scope.new(account, Candidate.all).resolve }

  context "having an account" do
    context "account is on a different organization" do
      let(:account) { create(:account) }

      it 'excludes candidate in resolved scope' do
        expect(resolved_scope).not_to include(candidate)
      end
    end

    context "account is on the same organization as the candidate" do
      let(:user) { create(:user, organization: candidate.organization) }
      let(:account) { create(:account, user: user) }

      it 'includes candidate in resolved scope' do
        expect(resolved_scope).to include(candidate)
      end
    end
  end
end

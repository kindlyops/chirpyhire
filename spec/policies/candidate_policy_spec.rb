require 'rails_helper'

RSpec.describe CandidatePolicy do
  subject { CandidatePolicy.new(organization, candidate) }

  let(:candidate) { create(:candidate) }

  let(:resolved_scope) { CandidatePolicy::Scope.new(organization, Candidate.all).resolve }

  context 'being a visitor' do
    let(:organization) { nil }

    it 'raises a NotAuthorizedError' do
      expect {
        subject
      }.to raise_error(Pundit::NotAuthorizedError)
    end
  end

  context 'having an organization' do
    context 'candidate does not belong to the organization' do
      let(:organization) { create(:organization) }

      it { should forbid_new_and_create_actions }
      it { should forbid_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should forbid_action(:show) }

      it 'excludes candidate in resolved scope' do
        expect(resolved_scope).not_to include(candidate)
      end
    end

    context 'candidate belongs to the organization' do
      let(:organization) { candidate.organization }

      it { should forbid_new_and_create_actions }
      it { should permit_edit_and_update_actions }
      it { should forbid_action(:destroy) }
      it { should permit_action(:show) }

      it { should permit_mass_assignment_of(:status) }

      it 'includes candidate in resolved scope' do
        expect(resolved_scope).to include(candidate)
      end
    end
  end
end

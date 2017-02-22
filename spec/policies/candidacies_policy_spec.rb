require 'rails_helper'

RSpec.describe CandidacyPolicy do
  subject { CandidacyPolicy.new(organization, candidacy) }

  let(:candidacy) { create(:person, :with_subscribed_candidacy).candidacy }
  let(:organization) { candidacy.subscriber.organization }

  let(:resolved_scope) { CandidacyPolicy::Scope.new(organization, Candidacy.all).resolve }

  it 'includes candidacy in resolved scope' do
    expect(resolved_scope).to include(candidacy)
  end

  context 'candidacy person is not subscribed to the organization' do
    let(:organization) { create(:organization) }

    it 'excludes candidacy in resolved scope' do
      expect(resolved_scope).not_to include(candidacy)
    end
  end
end

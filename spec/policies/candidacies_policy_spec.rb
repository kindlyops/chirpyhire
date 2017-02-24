require 'rails_helper'

RSpec.describe CandidacyPolicy do
  subject { CandidacyPolicy.new(organization, candidacy) }

  let(:candidacy) { create(:person, :with_subscribed_candidacy).candidacy }
  let(:organization) { candidacy.contact.organization }

  let(:resolved_scope) { CandidacyPolicy::Scope.new(organization, Candidacy.all).resolve }

  context 'not finished survey' do
    it 'excludes candidacy in resolved scope' do
      expect(resolved_scope).not_to include(candidacy)
    end
  end

  context 'finished survey' do
    before do
      candidacy.update(
        experience: :less_than_one,
        skin_test: true,
        availability: :live_in,
        transportation: :personal_transportation,
        zipcode: '30342',
        cpr_first_aid: true,
        certification: :pca
      )
    end

    it 'includes candidacy in resolved scope' do
      expect(resolved_scope).to include(candidacy)
    end
  end

  context 'candidacy person is not subscribed to the organization' do
    let(:organization) { create(:organization) }

    it 'excludes candidacy in resolved scope' do
      expect(resolved_scope).not_to include(candidacy)
    end
  end
end

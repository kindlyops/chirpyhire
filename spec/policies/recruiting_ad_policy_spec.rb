require 'rails_helper'

RSpec.describe RecruitingAdPolicy do
  describe 'scope' do
    subject { RecruitingAdPolicy::Scope.new(account, RecruitingAd.all) }

    context 'teams' do
      let(:team) { create(:team, :account) }
      let(:account) { team.accounts.first }
      let(:other_team) { create(:team, organization: team.organization) }
      let!(:recruiting_ad) { create(:recruiting_ad, team: other_team) }

      context 'account is on a different team than the recruiting_ad' do
        it 'does not include the recruiting_ad' do
          expect(subject.resolve).not_to include(recruiting_ad)
        end
      end

      context 'account is on same team as the recruiting_ad' do
        let(:team) { create(:team, :account) }
        let(:account) { team.accounts.first }
        let!(:recruiting_ad) { create(:recruiting_ad, team: team) }

        it 'does include the recruiting_ad' do
          expect(subject.resolve).to include(recruiting_ad)
        end
      end
    end
  end
end

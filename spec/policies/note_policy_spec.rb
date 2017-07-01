require 'rails_helper'

RSpec.describe NotePolicy do
  let(:account) { create(:account, :team) }
  let(:team) { account.teams.first }

  describe '.scope' do
    let(:resolved_scope) { NotePolicy::Scope.new(account, Note.all).resolve }

    context 'note is by another account on the team' do
      let(:contact) { create(:contact, organization: team.organization) }
      let(:team_member) { create(:account, organization: team.organization) }

      let!(:note) { create(:note, account: team_member, contact: contact) }

      it 'includes note in resolved scope' do
        expect(resolved_scope).to include(note)
      end
    end

    context 'note is by the account' do
      let(:contact) { create(:contact, organization: organization) }
      let!(:note) { create(:note, account: account, contact: contact) }

      it 'includes note in resolved scope' do
        expect(resolved_scope).to include(note)
      end
    end

    context 'note is by an account on another team' do
      let(:contact) { create(:contact) }
      let!(:note) { create(:note, contact: contact) }

      it 'excludes note in resolved scope' do
        expect(resolved_scope).not_to include(note)
      end
    end
  end

  describe 'policies' do
    context 'as the note author' do
      let(:contact) { create(:contact, organization: organization) }
      let!(:note) { create(:note, account: account, contact: contact) }
      subject { described_class.new(account, note) }

      it { is_expected.to permit_action(:show) }
      it { is_expected.to permit_action(:update) }
      it { is_expected.to permit_action(:destroy) }
    end

    context 'not the note author' do
      context 'on the same team' do
        let(:contact) { create(:contact, organization: organization) }
        let(:team_member) { create(:account, organization: team.organization) }

        let!(:note) { create(:note, account: team_member, contact: contact) }
        subject { described_class.new(account, note) }

        it { is_expected.to permit_action(:show) }
        it { is_expected.to forbid_action(:update) }
        it { is_expected.to forbid_action(:destroy) }
      end

      context 'on a different team' do
        let(:contact) { create(:contact) }
        let!(:note) { create(:note, contact: contact) }
        let(:other_team) { note.account }
        subject { described_class.new(account, note) }

        it { is_expected.to forbid_action(:show) }
        it { is_expected.to forbid_action(:update) }
        it { is_expected.to forbid_action(:destroy) }
      end
    end
  end
end

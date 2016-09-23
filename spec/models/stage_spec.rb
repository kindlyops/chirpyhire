require 'rails_helper'

RSpec.describe Stage, type: :model do
  context 'with an organization' do
    let(:organization1) { create(:organization, :with_subscription, :with_account) }
    describe 'validation' do
      let(:used_name) { organization1.stages.first.name }
      let(:organization2) { create(:organization, :with_subscription, :with_account) }

      it "doesn't allow duplicate names within an organization" do
        stage = organization1.stages.create(name: used_name, order: 10)
        expect(stage.errors).to include(:name)
      end
      it 'does allow duplicate names across organizations' do
        duplicate_name = 'new stage'

        organization1.stages.create(name: duplicate_name, order: 10)
        duplicate_stage_different_org =
          organization2.stages.create(name: duplicate_name, order: 10)

        expect(duplicate_stage_different_org.errors).to be_empty
      end
    end

    it '#after_destroy removes holes in an organizations stage order' do
      expect {
        organization1.ordered_stages.first.destroy
      }.to change { organization1.ordered_stages.last.order }.by(-1)
    end
  end

  describe 'defaults' do
    it 'has four defaults' do
      expect(StageDefaults.defaults.count).to eq(4)
    end
  end
end

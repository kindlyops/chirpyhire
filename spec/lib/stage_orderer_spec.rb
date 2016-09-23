require 'rails_helper'

RSpec.describe StageOrderer do
  let(:organization) { create(:organization, :with_account, :with_survey) }

  describe '#reorder' do
    let(:stage_count) { organization.ordered_stages.count }
    let!(:last_stage) { organization.ordered_stages.last }
    it 'successfully reorders stages' do
      new_stage_array = organization.ordered_stages.map do |stage|
        [stage.id, { order: (stage.order % stage_count) + 1 }]
      end
      StageOrderer.new(organization.id).reorder(Hash[new_stage_array])
      expect(organization.ordered_stages.first).to eq(last_stage)
    end
  end

  describe '#reset' do
    it 'succcesfully resets stages to prevent holes in ordering after deletion' do
      expect {
        organization.ordered_stages.first.destroy
      }.to change { organization.ordered_stages.last.order }.by(-1)
    end
  end
end

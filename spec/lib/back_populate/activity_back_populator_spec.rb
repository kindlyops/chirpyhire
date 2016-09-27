require 'rails_helper'

RSpec.describe BackPopulate::ActivityBackPopulator do
  let(:organization) { create(:organization) }

  let(:hired_activity) { create(:activity, properties: { status: 'Hired' }) }
  let(:hired_candidate) { create(:candidate, activities: [hired_activity], status: 'Hired', organization: organization) }
  let(:potential_activity) { create(:activity, properties: { status: 'Potential' }) }
  let(:potential_candidate) { create(:candidate, activities: [potential_activity], status: 'Potential', organization: organization) }
  let(:qualified_activity) { create(:activity, properties: { status: 'Qualified' }) }
  let(:qualified_candidate) { create(:candidate, activities: [qualified_activity], status: 'Qualified', organization: organization) }
  let(:bad_fit_activity) { create(:activity, properties: { status: 'Bad Fit' }) }
  let(:bad_fit_candidate) { create(:candidate, activities: [bad_fit_activity], status: 'Bad Fit', organization: organization) }

  describe '#populate' do
    context 'candidate does not have a stage_id activity, but has a status-based one' do
      it 'populates it properly for hired' do
        expect {
          BackPopulate::ActivityBackPopulator.populate(hired_candidate)
        }.to change { hired_activity.properties['stage_id'] }.from(nil).to(organization.hired_stage.id)
      end
      it 'populates it properly for potential' do
        expect {
          BackPopulate::ActivityBackPopulator.populate(potential_candidate)
        }.to change { potential_activity.properties['stage_id'] }.from(nil).to(organization.potential_stage.id)
      end
      it 'populates it properly for qualified' do
        expect {
          BackPopulate::ActivityBackPopulator.populate(qualified_candidate)
        }.to change { qualified_activity.properties['stage_id'] }.from(nil).to(organization.qualified_stage.id)
      end
      it 'populates it properly for bad_fit' do
        expect {
          BackPopulate::ActivityBackPopulator.populate(bad_fit_candidate)
        }.to change { bad_fit_activity.properties['stage_id'] }.from(nil).to(organization.bad_fit_stage.id)
      end
    end
    context 'candidate already has a stage based activity' do
      let(:bad_fit_new_activity) { create(:activity, properties: { stage_id: organization.bad_fit_stage.id }) }
      let(:bad_fit_new_candidate) { create(:candidate, activities: [bad_fit_new_activity], status: 'Bad Fit', organization: organization) }
      it 'does nothing' do
        expect {
          BackPopulate::ActivityBackPopulator.populate(bad_fit_new_candidate)
        }.not_to change { bad_fit_new_activity.properties['stage_id'] }
      end
    end
  end
end

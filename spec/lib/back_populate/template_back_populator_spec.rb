require 'rails_helper'
require 'rake'

RSpec.describe 'BackPopulateNotUnderstood' do
  let(:organization) { create(:organization) }
  let!(:survey) { create(:survey, organization: organization) }
  describe 'verify' do
    before(:each) do
      load "#{Rails.root}/lib/tasks/templates/back_populate_not_understood.rake"
      Rake::Task.define_task(:environment)
    end
    context "organization does not have a 'not understood' template" do
      it 'adds a template' do
        not_understood = organization.templates.last
        organization.survey.update!(not_understood_id: nil)
        not_understood.destroy!
        expect(organization.templates.count).to eq(3)
        Rake::Task["templates:back_populate_not_understood"].invoke
        expect(organization.templates.count).to eq(4)
      end
    end
    context "organization does have a 'not understood' template" do
      it 'does not add a template' do
        Rake::Task["templates:back_populate_not_understood"].invoke
        expect(organization.templates.count).to eq(4)
      end
    end
  end
end

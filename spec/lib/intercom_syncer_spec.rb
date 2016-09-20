require 'rails_helper'

RSpec.describe IntercomSyncer, vcr: { cassette_name: 'IntercomSyncer' } do
  let(:phone_number) { '+1234567890' }
  let(:organization) { create(:organization, :with_subscription, phone_number: phone_number, id: 1001) }

  before(:each) do
    $intercom.companies.create(company_id: organization.id)
  end

  let(:fetch_company) do
    -> { $intercom.companies.find(company_id: organization.id) }
  end

  subject { IntercomSyncer.new(organization) }

  it 'sets the candidates count' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['candidates_count'] }.from(nil).to(0)
  end

  it 'sets the qualified candidates count' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['qualified_candidates_count'] }.from(nil).to(0)
  end

  it 'sets the hired candidates count' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['hired_candidates_count'] }.from(nil).to(0)
  end

  it 'sets the bad fit candidates count' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['bad_fit_candidates_count'] }.from(nil).to(0)
  end

  it 'sets the trial percentage remaining' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['trial_percentage_remaining'] }.from(nil).to(100)
  end

  it 'sets the trial remaining messages count' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['trail_remaining_messages_count'] }.from(nil).to(500)
  end

  it 'sets the subscription state' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['subscription_state'] }.from(nil).to('trialing')
  end

  it 'sets the phone number' do
    expect{
      subject.call
    }.to change { fetch_company.call.custom_attributes['phone_number'] }.from(nil).to(phone_number.phony_formatted)
  end
end

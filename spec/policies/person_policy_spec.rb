require 'rails_helper'

RSpec.describe PersonPolicy do

  let(:organization) { create(:organization) }
  let(:account) { create(:account, organization: organization) }

  let(:resolved_scope) { PersonPolicy::Scope.new(account, Person.all).resolve }

  describe 'scope' do
    let(:people) { create_list(:person, 3) }

    context 'people that have contacts on the organization' do
      let!(:contact_people) do
        people.each do |person|
          create(:contact, person: person, organization: organization)
        end
      end

      it 'includes the people' do
        expect(resolved_scope).to include(*contact_people)
      end
    end

    context 'people that have broker_contacts' do
      let!(:broker_contact_people) do
        people.each do |person|
          create(:broker_contact, person: person)
        end
      end

      it 'includes the people' do
        expect(resolved_scope).to include(*broker_contact_people)
      end
    end

    context 'people that have contacts on other organizations' do
      let!(:other_contact_people) do
        people.each do |person|
          create(:contact, person: person)
        end
      end
      
      context 'without broker contacts' do
        it 'excludes the people' do
          expect(resolved_scope).not_to include(*other_contact_people)
        end
      end

      context 'with broker contacts' do
        before do
          other_contact_people.each { |p| create(:broker_contact, person: p) }
        end

        it 'includes the people' do
          expect(resolved_scope).to include(*other_contact_people)
        end
      end
    end

    context 'people that have no contacts or broker_contacts' do
      let!(:contactless_people) { people }

      it 'excludes the people' do
        expect(resolved_scope).not_to include(*contactless_people)
      end
    end
  end
end

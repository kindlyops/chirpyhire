require 'rails_helper'

RSpec.describe Contact do
  describe '#content' do
    context 'candidate' do
      subject { create(:contact, :with_complete_candidacy) }

      context 'handle' do
        it 'includes the handle' do
          expect(subject.reload.content).to include(subject.handle.to_s)
        end
      end

      context 'phone number' do
        it 'includes the phone number' do
          expect(subject.reload.content).to include(subject.phone_number[2..-1].to_s)
        end
      end

      context 'zipcode' do
        let(:zipcode) { '22902' }

        before do
          subject.person.candidacy.update(zipcode: zipcode)
        end

        it 'includes the zipcode' do
          expect(subject.reload.content).to include(zipcode.to_s)
        end
      end

      context 'availability' do
        let(:availability) { :live_in }

        before do
          subject.person.candidacy.update(availability: availability)
        end

        it 'includes the availability' do
          expect(subject.reload.content).to include('Live-In')
        end
      end

      context 'transportation' do
        let(:transportation) { :personal_transportation }

        before do
          subject.person.candidacy.update(transportation: transportation)
        end

        it 'includes the transportation' do
          expect(subject.reload.content).to include('Personal')
        end
      end

      context 'screened status' do
        let(:screened) { true }

        before do
          subject.update(screened: screened)
        end

        it 'includes the screened status' do
          expect(subject.reload.content).to include('Screened')
        end
      end

      context 'experience' do
        let(:experience) { :six_or_more }

        before do
          subject.person.candidacy.update(experience: experience)
        end

        it 'includes the experience' do
          expect(subject.reload.content).to include('6+ years')
        end
      end

      context 'certification' do
        let(:certification) { :cna }

        before do
          subject.person.candidacy.update(certification: certification)
        end

        it 'includes the certification' do
          expect(subject.reload.content).to include('CNA')
        end
      end

      context 'skin test status' do
        let(:skin_test) { true }

        before do
          subject.person.candidacy.update(skin_test: skin_test)
        end

        it 'includes the skin test status' do
          expect(subject.reload.content).to include('Skin / TB Test')
        end
      end

      context 'cpr status' do
        let(:cpr_first_aid) { true }

        before do
          subject.person.candidacy.update(cpr_first_aid: cpr_first_aid)
        end

        it 'includes the cpr status' do
          expect(subject.reload.content).to include('CPR')
        end
      end

      context 'subscribed status' do
        let(:subscribed) { true }

        before do
          subject.update(subscribed: subscribed)
        end

        it 'includes the subscribed status' do
          expect(subject.reload.content).to include('Subscribed')
        end
      end

      context 'status' do
        it 'includes the status' do
          expect(subject.reload.content).to include('Promising')
        end
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Candidacy do
  subject { create(:person, :with_subscribed_candidacy).candidacy }

  describe '#ideal?' do
    let(:ideal_candidate) { create(:ideal_candidate) }
    context 'complete' do
      before do
        subject.update(state: :complete)
      end

      context 'and ideal candidate does not have the zipcode' do
        before do
          subject.update(zipcode: '22902')
        end

        it 'is false' do
          expect(subject.ideal?(ideal_candidate)).to eq(false)
        end
      end

      context 'no transportation' do
        before do
          subject.update(transportation: :no_transportation)
        end

        it 'is false' do
          expect(subject.ideal?(ideal_candidate)).to eq(false)
        end
      end

      context 'no experience' do
        before do
          subject.update(experience: :no_experience)
        end

        it 'is false' do
          expect(subject.ideal?(ideal_candidate)).to eq(false)
        end
      end

      context 'no certification' do
        before do
          subject.update(transportation: :no_transportation)
        end

        it 'is false' do
          expect(subject.ideal?(ideal_candidate)).to eq(false)
        end
      end

      context 'no skin test' do
        before do
          subject.update(skin_test: false)
        end

        it 'is false' do
          expect(subject.ideal?(ideal_candidate)).to eq(false)
        end
      end

      context 'no cpr first aid' do
        before do
          subject.update(cpr_first_aid: false)
        end

        it 'is false' do
          expect(subject.ideal?(ideal_candidate)).to eq(false)
        end
      end

      context 'otherwise' do
        before do
          subject.update(
            experience: :one_to_five,
            skin_test: true,
            availability: :hourly,
            transportation: :personal_transportation,
            zipcode: '30342',
            cpr_first_aid: true,
            certification: :cna
          )
        end

        it 'is true' do
          expect(subject.ideal?(ideal_candidate)).to eq(true)
        end
      end
    end

    context 'incomplete' do
      it 'is false' do
        expect(subject.ideal?(ideal_candidate)).to eq(false)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Inquiry do
  describe '#unanswered?' do
    context 'with answer' do
      let(:inquiry) { create(:inquiry, :with_answer) }

      it 'is false' do
        expect(inquiry.unanswered?).to eq(false)
      end
    end

    context 'without answer' do
      let(:inquiry) { create(:inquiry) }

      it 'is true' do
        expect(inquiry.unanswered?).to eq(true)
      end
    end
  end

  describe '#activity tracking' do
    let(:inquiry) { create(:inquiry) }
    let(:question) { create(:question) }
    describe 'update' do
      context 'changing not understood count' do
        it 'creates an activity' do
          expect {
            inquiry.update!(not_understood_count: 1)
          }.to(change {
                 PublicActivity::Activity.where(
                   trackable_type: 'Inquiry'
                 ).count
               }.by(1))
        end

        it 'has owner id and question type' do
          inquiry.update!(not_understood_count: 1)
          expect(inquiry.activities.last.owner).to eq(inquiry.organization)
          expect(inquiry.activities.last.properties['not_understood_count']).to(
            eq(inquiry.not_understood_count)
          )
        end
      end

      context 'updating something else' do
        it 'does not create an activity' do
          expect {
            inquiry.update!(question_id: question.id)
          }.not_to change {
            PublicActivity::Activity.where(
              trackable_type: 'Inquiry'
            ).count
          }
        end
      end
    end

    describe 'create' do
      it 'does not create an activity' do
        expect {
          inquiry
        }.not_to change {
          PublicActivity::Activity.where(
            trackable_type: 'Inquiry'
          ).count
        }
      end
    end

    describe 'destroy' do
      it 'does not create an activity' do
        expect {
          inquiry.destroy!
        }.not_to change {
          PublicActivity::Activity.where(
            trackable_type: 'Inquiry'
          ).count
        }
      end
    end
  end
end
